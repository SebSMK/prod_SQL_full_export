SELECT 

modif.csid AS csid,
MAX (modif.updatedat)   AS updatedat

FROM
(

/* object created/changed/deleted */

        SELECT                        
                hierarchy0.name                        AS csid,
                MAX (collectionspace_core.updatedat)   AS updatedat
        
        FROM public.collectionspace_core
        
        LEFT JOIN public.collectionobjects_common ON collectionspace_core.id = collectionobjects_common.id
        LEFT JOIN public.hierarchy hierarchy0 ON collectionobjects_common.id = hierarchy0.id        
        
        WHERE collectionspace_core.tenantid = 5
                AND collectionspace_core.updatedat &gt; '${dih.last_index_time}'
                AND collectionspace_core.refname LIKE '%collectionobject%'
        
        GROUP BY csid


UNION

        /* citation authority changed */
        SELECT
        
                
                hierarchy0.name                        AS csid,
                MAX (collectionspace_core.updatedat)   AS updatedat
        
        FROM public.collectionspace_core
        
        LEFT JOIN public.referencegroup ON collectionspace_core.refname = referencegroup.reference 
        LEFT JOIN public.hierarchy hierarchy_ref ON referencegroup.id = hierarchy_ref.id AND hierarchy_ref.primarytype = 'referenceGroup'
        LEFT JOIN public.collectionobjects_common ON collectionobjects_common.id = hierarchy_ref.parentid 
        LEFT JOIN public.hierarchy hierarchy0 ON collectionobjects_common.id = hierarchy0.id
        
        WHERE collectionspace_core.tenantid = 5
                AND collectionspace_core.updatedat &gt; '${dih.last_index_time}'
                AND collectionspace_core.refname LIKE '%citationauthorities%'
        
        GROUP BY csid


UNION

        /* person or organisation authority changed (artist) */
        SELECT
        
                
                hierarchy0.name                        AS csid,
                MAX (collectionspace_core.updatedat)   AS updatedat
        
        FROM public.collectionspace_core
        
        LEFT JOIN public.faobjectproductionpersongroup faobjectproductionpersongroup_artist ON collectionspace_core.refname = faobjectproductionpersongroup_artist.faobjectproductionperson 
        LEFT JOIN public.hierarchy hierarchy_prodgroup ON faobjectproductionpersongroup_artist.id = hierarchy_prodgroup.id AND hierarchy_prodgroup.primarytype = 'faObjectProductionPersonGroup'
        LEFT JOIN public.collectionobjects_common ON collectionobjects_common.id = hierarchy_prodgroup.parentid 
        LEFT JOIN public.hierarchy hierarchy0 ON collectionobjects_common.id = hierarchy0.id
        
        WHERE collectionspace_core.tenantid = 5
                AND collectionspace_core.updatedat &gt; '${dih.last_index_time}'
                AND (collectionspace_core.refname LIKE '%personauthorities%' OR collectionspace_core.refname LIKE '%orgauthorities%')
        
        GROUP BY csid


UNION

        /* person authority changed (portrait) */
        SELECT
        
                
                hierarchy0.name                        AS csid,
                MAX (collectionspace_core.updatedat)   AS updatedat
        
        
        FROM public.collectionspace_core
        
        LEFT JOIN public.collectionobjects_common_contentpersons portrait ON collectionspace_core.refname = portrait.item 
        LEFT JOIN public.collectionobjects_common ON collectionobjects_common.id = portrait.id 
        LEFT JOIN public.hierarchy hierarchy0 ON collectionobjects_common.id = hierarchy0.id
        
        WHERE collectionspace_core.tenantid = 5
                AND collectionspace_core.updatedat &gt; '${dih.last_index_time}'
                AND collectionspace_core.refname LIKE '%personauthorities%'
        
        GROUP BY csid


UNION

        /* place authority changed (topografisk motiv) */
        SELECT
        
                
                hierarchy0.name                        AS csid,
                MAX (collectionspace_core.updatedat)   AS updatedat
        
        
        FROM public.collectionspace_core
        
        LEFT JOIN public.collectionobjects_common_contentplaces contentplaces ON collectionspace_core.refname = contentplaces.item 
        LEFT JOIN public.collectionobjects_common ON collectionobjects_common.id = contentplaces.id 
        LEFT JOIN public.hierarchy hierarchy0 ON collectionobjects_common.id = hierarchy0.id
        
        WHERE collectionspace_core.tenantid = 5
                AND collectionspace_core.updatedat &gt; '${dih.last_index_time}'
                AND collectionspace_core.refname LIKE '%placeauthorities%'
        
        GROUP BY csid

UNION

       /* related acquisition / placering / media */
        SELECT
        
                relations_common.subjectcsid   AS csid,
                MAX (collectionspace_core.updatedat)   AS updatedat
        
        FROM public.collectionspace_core
        
        LEFT JOIN public.hierarchy hierarchy_relation ON hierarchy_relation.id = collectionspace_core.id
        LEFT JOIN public.relations_common ON hierarchy_relation.name = relations_common.objectcsid AND relations_common.subjectdocumenttype = 'CollectionObject'
        
        WHERE collectionspace_core.tenantid = 5
                AND collectionspace_core.updatedat &gt; '${dih.last_index_time}'
        
        GROUP BY csid
        
UNION        
        /* related as object */
        SELECT
        
                relations_common.objectcsid   AS csid,
                MAX (collectionspace_core.updatedat)   AS updatedat
       
        FROM public.collectionspace_core
        
        LEFT JOIN public.relations_common ON relations_common.id = collectionspace_core.id AND relations_common.subjectdocumenttype = 'CollectionObject' 
        
        WHERE collectionspace_core.tenantid = 5
                AND collectionspace_core.updatedat &gt; '${dih.last_index_time}'              
        
        GROUP BY csid    
        
 UNION        
        
        /* related as subject */
        SELECT
        
                relations_common.subjectcsid   AS csid,
                MAX (collectionspace_core.updatedat)   AS updatedat
       
        FROM public.collectionspace_core
        
        LEFT JOIN public.relations_common ON relations_common.id = collectionspace_core.id AND relations_common.subjectdocumenttype = 'CollectionObject' 
        
        WHERE collectionspace_core.tenantid = 5
                AND collectionspace_core.updatedat &gt; '${dih.last_index_time}'               
        
        GROUP BY csid  
        
) AS modif

WHERE modif.csid IS NOT NULL 

GROUP BY csid