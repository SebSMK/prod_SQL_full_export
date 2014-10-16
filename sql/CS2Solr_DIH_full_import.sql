SELECT

collectionobjects_common.objectnumber                                 AS id,

smkstructureddatesmkgroup_obj_acq_date.datesmkdisplaytext             AS acq_date,
smkstructureddatesmkgroup_obj_acq_date.datesmkearliestscalarvalue	AS acq_date_earliest,
smkstructureddatesmkgroup_obj_acq_date.datesmklatestscalarvalue		AS acq_date_latest,
smkstructureddatesmkgroup_obj_acq_date.datesmkdisplayengtext          AS acq_date_eng,
acquisitions_common.acquisitionnote                                   AS acq_note,
acquisitions_common.acquisitionreason                                 AS acq_reason,
vocabularyitems_common_acq.displayname                                AS acq_method,
CAST (acquisitions_common.originalobjectpurchasepricevalue AS TEXT)   AS acq_price,
vocabularyitems_common_purch_curr.displayname                         AS acq_price_currency,
CAST (acquisitions_common.grouppurchasepricevalue AS TEXT)            AS acq_samlet_price,
vocabularyitems_common_group_purch_curr.displayname                   AS acq_samlet_price_currency,
acquisitions_smk.smkacquistionsource                                  AS acq_source,

collectionobjects_smk.smksupport                                      AS bagklaedning,

citations.citations                                                   AS citations,
hierarchy0.name                                                       AS csid,  
contentnote.content_note                                              AS content_notes,
comments.comments                                                     AS comments,
collectionobjects_finearts.facopyrightstatement                       AS copyright,

farelatedworklabelgroup.farelatedworklabel                            AS description_note,
collectionobjects_common.distinguishingfeatures                       AS distinguishingfeatures,

ejer.ejer                                                             AS ejer,
exhibitions.exhibitionvenue                                           AS exhibitionvenues,
array_to_string(media.externalurl,',')                                AS externalurl,

vocabularyitems_format.displayname                                    AS form,
collectionobjects_finearts.famoulder                                  AS formeri,

betegnelser.betegnelser_data                                          AS inscription_data,
collectionobjects_smk.smkinsurancedate                                AS insur_date,
collectionobjects_smk.smkinsurancevalue                               AS insur_value,
vocabularyitems_common_insurance_curr.displayname                     AS insur_curr,

littref.litt_references                                               AS litt_references,
location.location_date                                                AS location_date,
location.location_name                                                AS location_name,
location.location_note                                                AS location_note,
collectionobjects_common.copynumber                                   AS location_kks_kas,
core.updatedat                                                        AS last_update,

materiale.materiale                                                   AS materiale,
multi_work.multi_work_ref                                             AS multi_work_ref,
collectionobjects_common.numberofobjects                              AS numberofobjects,
meas_all.meas_all                                                     AS meas_all,
collectionobjects_smk.smkmicroclimateframe                            AS mikroklimaramme,

collectionobjects_finearts.faorientationremarks                       AS note_elementer,

collectionobjects_finearts.faorientationdescription                   AS opstilling,
collectionobjects_common.objectnumber                                 AS objectnumber,
object_all_production_dates.production_dates                          AS object_all_production_dates,
object_all_production_dates.datesmkearliestscalarvalue				AS object_production_date_earliest,
object_all_production_dates.datesmklatestscalarvalue				AS object_production_date_latest,
objectproductionnote.objectproductionnote                             AS object_production_note,
production_place.production_place                                     AS object_production_place,
concepttermgroup.termdisplayname                                      AS object_type,
objbriefdescriptions.objbriefdescriptions                             AS object_briefdescriptions,
objectophavsbeskrivelse.objectophavsbeskrivelse                       AS objectophavsbeskrivelse,
collectionobjects_common.editionnumber                                AS oplag,
other_numbers.other_numbers                                           AS other_numbers,

faproductiontechniquegroup.faproductiontechnique                      AS prod_technique_all,
proveniens.proveniens                                                 AS proveniens,
collectionobjects_common.physicaldescription                          AS physicaldescription,
portrait_person.portrait_person                                       AS portrait_person,
collectionobjects_smk.smkposter                                       AS plakat,
collectionobjects_smk.smkpostcard                                     AS postkort,
producent.producents_data                                             AS producents_data,

related_work.title_dk                                                 AS related_works_title_dk,
reference_text.reference_text                                         AS reference_texts,

collectionobjects_finearts.fastatedescription                         AS stadium,
sikkerhed.status                                                      AS sikkerhedstatus,
shape.displayname                                                     AS shape,

title_all.title_all                                                   AS title_all,
techniquearticle.techniquearticle                                     AS techniquearticle,
topografisk_motiv                                                     AS topografisk_motiv,

vaerkstatus.vaerkstatus                                               AS vaerkstatus,

collectionobjects_finearts.fawatermark                                AS watermark


FROM public.collectionobjects_common collectionobjects_common

INNER JOIN public.hierarchy hierarchy0 ON (collectionobjects_common.id = hierarchy0.id)

/* - object -*/
        /* object fabrication */
        LEFT JOIN(
                
                SELECT
                object_hierarchy0.objid AS objid,
                string_agg(
                        format('%s;--;%s', 
                                faproductiontechniquegroup.faproductiontechnique, 
                                faproductiontechniquegroup.faproductiontechniquelanguage) 
                 ,';-;')AS faproductiontechnique
                
                FROM public.object_hierarchy0
                
                LEFT JOIN faproductiontechniquegroup ON object_hierarchy0.primarytype_id = faproductiontechniquegroup.id 
                        
                WHERE object_hierarchy0.primarytype = 'faProductionTechniqueGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'  
                
                GROUP BY
                        object_hierarchy0.objid
                
        ) AS faproductiontechniquegroup

        ON collectionobjects_common.id = faproductiontechniquegroup.objid
        
        /* object technique article */
        LEFT JOIN(
               
                SELECT
                object_hierarchy0.objid AS objid,
                string_agg(smktechnicalappliancegroup.smkappliance,';-;') AS techniquearticle

                FROM public.object_hierarchy0
                
                LEFT JOIN smktechnicalappliancegroup ON object_hierarchy0.primarytype_id = smktechnicalappliancegroup.id 
                        
                WHERE object_hierarchy0.primarytype = 'smkTechnicalApplianceGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'  

                GROUP BY
                        object_hierarchy0.objid
                                                       
        ) AS techniquearticle

        ON collectionobjects_common.id = techniquearticle.objid
        
        /* objet materiale */
        
        LEFT JOIN(
               
                SELECT
                
                object_hierarchy0.objid AS objid,
                string_agg(
                        format('%s;--;%s', 
                                concepttermgroup.termdisplayname, 
                                conceptauthorities_common.displayname) 
                 ,';-;')AS materiale

                FROM public.object_hierarchy0
                
                LEFT JOIN famaterialgroup ON object_hierarchy0.primarytype_id = famaterialgroup.id 
                LEFT JOIN concepts_common ON famaterialgroup.famaterial = concepts_common.refname
                LEFT JOIN hierarchy hier_auth ON hier_auth.name = concepts_common.inauthority
                LEFT JOIN conceptauthorities_common ON conceptauthorities_common.id = hier_auth.id
                LEFT JOIN hierarchy hier_concept ON hier_concept.parentid = concepts_common.id
                LEFT JOIN concepttermgroup ON concepttermgroup.id = hier_concept.id
                        
                WHERE object_hierarchy0.primarytype = 'faMaterialGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'  
                        

                GROUP BY
                        object_hierarchy0.objid
                                                       
        ) AS materiale

        ON collectionobjects_common.id = materiale.objid
        
        /* object production place */
        LEFT JOIN(
               
                SELECT
                object_hierarchy0.objid AS objid,
                string_agg(
                        format('%s;--;%s', 
                                placetermgroup.termdisplayname, 
                                role.displayname) 
                 ,';-;') AS production_place
                 
                FROM public.object_hierarchy0
                
                LEFT JOIN objectproductionplacegroup ON object_hierarchy0.primarytype_id = objectproductionplacegroup.id 
                LEFT JOIN public.places_common ON places_common.refname = objectproductionplacegroup.objectproductionplace
                LEFT JOIN hierarchy hierarchy_places ON hierarchy_places.parentid = places_common.id
                LEFT JOIN public.placetermgroup ON placetermgroup.id = hierarchy_places.id
                LEFT JOIN vocabularyitems_common role ON role.refname = objectproductionplacegroup.objectproductionplacerole
                        
                WHERE object_hierarchy0.primarytype = 'objectProductionPlaceGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'  

                GROUP BY
                        object_hierarchy0.objid
                                                       
        ) AS production_place

        ON collectionobjects_common.id = production_place.objid
        
        /* object acquisition*/
        LEFT JOIN public.hierarchy hierarchy_obj_acq ON collectionobjects_common.id = hierarchy_obj_acq.id AND hierarchy_obj_acq.primarytype = 'CollectionObjectTenant5'
        LEFT JOIN public.relations_common relations_common_obj_acq ON relations_common_obj_acq.subjectcsid = hierarchy_obj_acq.name AND relations_common_obj_acq.objectdocumenttype = 'Acquisition'
        LEFT JOIN public.hierarchy hierarchy_obj_acq_smk ON relations_common_obj_acq.objectcsid = hierarchy_obj_acq_smk.name
        LEFT JOIN public.acquisitions_common acquisitions_common ON acquisitions_common.id = hierarchy_obj_acq_smk.id
        LEFT JOIN public.vocabularyitems_common vocabularyitems_common_acq ON vocabularyitems_common_acq.refname = acquisitions_common.acquisitionmethod
        LEFT JOIN public.acquisitions_smk acquisitions_smk ON acquisitions_smk.id = hierarchy_obj_acq_smk.id

        /* object acquisition - purchase price currency*/
        LEFT JOIN public.vocabularyitems_common vocabularyitems_common_purch_curr ON vocabularyitems_common_purch_curr.refname = acquisitions_common.originalobjectpurchasepricecurrency
        LEFT JOIN public.vocabularyitems_common vocabularyitems_common_group_purch_curr ON vocabularyitems_common_group_purch_curr.refname = acquisitions_common.grouppurchasepricecurrency

        /* object acquisition date */
        LEFT JOIN public.hierarchy hierarchy_obj_acq_date ON acquisitions_common.id = hierarchy_obj_acq_date.parentid AND hierarchy_obj_acq_date.name = 'acquisitions_smk:smkAcquisitionDate'
        LEFT JOIN public.smkstructureddatesmkgroup smkstructureddatesmkgroup_obj_acq_date ON smkstructureddatesmkgroup_obj_acq_date.id = hierarchy_obj_acq_date.id
             
         /* object - all production dates */
        LEFT JOIN(

                SELECT

                object_hierarchy0.objid AS objectid,
                string_agg(
                        format('%s;--;%s;--;%s;--;%s;--;%s',                                                         
                                voc_qual.displayname,
                                smkstructureddatesmkgroup_obj_prod_date.datesmkdisplaytext,
                                smkstructureddatesmkgroup_obj_prod_date.datesmkearliestscalarvalue,
                                smkstructureddatesmkgroup_obj_prod_date.datesmklatestscalarvalue,
                                smkstructureddatesmkgroup_obj_prod_date.datesmkdisplayengtext) 
                 ,';-;') AS production_dates,
                 smkstructureddatesmkgroup_obj_prod_date.datesmkearliestscalarvalue,
                 smkstructureddatesmkgroup_obj_prod_date.datesmklatestscalarvalue

                FROM public.object_hierarchy0
                
                LEFT JOIN smkobjectproductiondategroup ON object_hierarchy0.primarytype_id = smkobjectproductiondategroup.id 
                LEFT JOIN hierarchy hierarchy_smk_obj_prod_date ON smkobjectproductiondategroup.id = hierarchy_smk_obj_prod_date.parentid AND hierarchy_smk_obj_prod_date.name = 'smkObjectProductionDate'
                LEFT JOIN smkstructureddatesmkgroup smkstructureddatesmkgroup_obj_prod_date ON smkstructureddatesmkgroup_obj_prod_date.id = hierarchy_smk_obj_prod_date.id
                LEFT JOIN vocabularyitems_common voc_qual ON voc_qual.refname = smkobjectproductiondategroup.smkobjectproductiondatequalifier
        
                WHERE object_hierarchy0.primarytype = 'smkObjectProductionDateGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'  

                GROUP BY
                        object_hierarchy0.objid,
                        smkstructureddatesmkgroup_obj_prod_date.datesmkearliestscalarvalue,
                 		smkstructureddatesmkgroup_obj_prod_date.datesmklatestscalarvalue

        ) AS object_all_production_dates

        ON collectionobjects_common.id = object_all_production_dates.objectid
     
        /* object - note to production date */
        LEFT JOIN(

                SELECT

                object_hierarchy0.objid AS objectid,
                string_agg(smkobjectproductionnotegroup.smkobjectproductionnote,';-;') AS objectproductionnote

                FROM public.object_hierarchy0
                
                LEFT JOIN smkobjectproductionnotegroup ON object_hierarchy0.primarytype_id = smkobjectproductionnotegroup.id 
                        
                WHERE object_hierarchy0.primarytype = 'smkObjectProductionNoteGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'  

                GROUP BY
                        object_hierarchy0.objid
              

        ) AS objectproductionnote

        ON collectionobjects_common.id = objectproductionnote.objectid

        /* object - ophavsbeskrivelse */
        LEFT JOIN(

                SELECT

                object_hierarchy0.objid AS objectid,
                string_agg(facreatordescriptiongroup.facreatordescription,';-;') AS objectophavsbeskrivelse

                FROM public.object_hierarchy0
                
                LEFT JOIN facreatordescriptiongroup ON object_hierarchy0.primarytype_id = facreatordescriptiongroup.id 
                        
                WHERE object_hierarchy0.primarytype = 'faCreatorDescriptionGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'  

                GROUP BY
                        object_hierarchy0.objid

        ) AS objectophavsbeskrivelse

        ON collectionobjects_common.id = objectophavsbeskrivelse.objectid

        /* object - kollation */
        LEFT JOIN(

                SELECT

                collectionobjects_common.id AS objectid,
                string_agg(obj_briefdescriptions.item,';-;') AS objbriefdescriptions

                FROM public.collectionobjects_common collectionobjects_common

                INNER JOIN public.hierarchy hierarchy0 ON (collectionobjects_common.id = hierarchy0.id)
                LEFT JOIN public.collectionobjects_common_briefdescriptions obj_briefdescriptions ON obj_briefdescriptions.id = collectionobjects_common.id

                WHERE hierarchy0.name = '${objects.csid}'

                GROUP BY objectid

        ) AS objbriefdescriptions

        ON collectionobjects_common.id = objectproductionnote.objectid


        /* object type */
        LEFT JOIN public.collectionobjects_smk collectionobjects_smk ON collectionobjects_common.id = collectionobjects_smk.id
        LEFT JOIN public.concepts_common concepts_common ON concepts_common.refname = collectionobjects_smk.smkobjectname
        LEFT JOIN public.hierarchy hierarchy_smk_object_type ON concepts_common.id = hierarchy_smk_object_type.parentid AND hierarchy_smk_object_type.primarytype = 'conceptTermGroup'
        LEFT JOIN public.concepttermgroup concepttermgroup ON concepttermgroup.id = hierarchy_smk_object_type.id

        /* object history (proveniens) */
        LEFT JOIN(

                SELECT

                object_hierarchy0.objid AS objectid,
                string_agg(smkobjecthistorygroup.smkobjecthistory,';-;') AS proveniens

                FROM public.object_hierarchy0
                
                LEFT JOIN smkobjecthistorygroup ON object_hierarchy0.primarytype_id = smkobjecthistorygroup.id 
                        
                WHERE object_hierarchy0.primarytype = 'smkObjectHistoryGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'  

                GROUP BY
                        object_hierarchy0.objid
                              
        ) AS proveniens

        ON collectionobjects_common.id = proveniens.objectid
        
        /* object shape */
        LEFT JOIN public.collectionobjects_finearts ON collectionobjects_finearts.id = collectionobjects_common.id
        LEFT JOIN vocabularyitems_common shape ON shape.refname = collectionobjects_finearts.fadimensionsshape
        
/* - artist / printer / editor -*/

  LEFT JOIN(
         SELECT
         objectid,
         string_agg(sub_producent.producents_data,';-;') AS producents_data
        
         FROM(
              
               /* a person */
               
                        SELECT
        
                        object_hierarchy0.objid AS objectid,
                        object_hierarchy0.pos,                                                
                        
                         format ('person;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s' ,
                                                                        
                                vocabularyitems_common_art_producent.displayname,
                                
                                (persontermgroup_producent.termdisplayname),                                                        
        
                                smkstructureddatesmkgroup_producent_birth.datesmkthirddateyear,
                                
                               	smkstructureddatesmkgroup_producent_birth.datesmkdisplaytext,
        
                               	smkstructureddatesmkgroup_producent_birth.datesmkdisplayengtext,
                                
                                smkstructureddatesmkgroup_producent_death.datesmkthirddateyear,
        
                                smkstructureddatesmkgroup_producent_death.datesmkdisplaytext,
                                
                                smkstructureddatesmkgroup_producent_death.datesmkdisplayengtext,
        
                                initcap(vocabularyitems_common_producent.displayname),
                                
                                initcap(vocabularyitems_common_producent.description)
                                                                                                        
                        )
                        AS producents_data
        
                        FROM public.object_hierarchy0
        
                        LEFT JOIN faobjectproductionpersongroup faobjectproductionpersongroup_producent  ON object_hierarchy0.primarytype_id = faobjectproductionpersongroup_producent.id                         
        
                        /*  nationality */
                        LEFT JOIN public.persons_common persons_common_producent ON persons_common_producent.refname = faobjectproductionpersongroup_producent.faobjectproductionperson
                        LEFT JOIN public.persons_common_nationalities persons_common_nationalities_producent ON persons_common_producent.id = persons_common_nationalities_producent.id AND persons_common_nationalities_producent.pos = 0
                        LEFT JOIN public.vocabularyitems_common vocabularyitems_common_producent ON vocabularyitems_common_producent.refname = persons_common_nationalities_producent.item
        
                        /*  name */
                        RIGHT JOIN public.hierarchy hierarchy_producent_1 ON persons_common_producent.id = hierarchy_producent_1.parentid AND hierarchy_producent_1.primarytype = 'personTermGroup' AND hierarchy_producent_1.pos = 0
                        LEFT JOIN public.persontermgroup persontermgroup_producent ON persontermgroup_producent.id = hierarchy_producent_1.id
        
                        /*  birth and death date */
                        LEFT JOIN public.hierarchy hierarchy_producent_2 ON persons_common_producent.id = hierarchy_producent_2.parentid AND hierarchy_producent_2.name = 'persons_smk:smkDeathDate'
                        LEFT JOIN public.smkstructureddatesmkgroup smkstructureddatesmkgroup_producent_death ON smkstructureddatesmkgroup_producent_death.id = hierarchy_producent_2.id
                        LEFT JOIN public.hierarchy hierarchy_producent_3 ON persons_common_producent.id  = hierarchy_producent_3.parentid AND hierarchy_producent_3.name = 'persons_smk:smkBirthDate'
                        LEFT JOIN public.smkstructureddatesmkgroup smkstructureddatesmkgroup_producent_birth ON smkstructureddatesmkgroup_producent_birth.id = hierarchy_producent_3.id
        
                        /*  role */
                        LEFT JOIN public.vocabularyitems_common vocabularyitems_common_art_producent ON faobjectproductionpersongroup_producent.faobjectproductionpersonrole = vocabularyitems_common_art_producent.refname
        
                        WHERE object_hierarchy0.primarytype = 'faObjectProductionPersonGroup'                 
                                AND object_hierarchy0.csid = '${objects.csid}'  
        
                        GROUP BY
                            objectid,
                            persontermgroup_producent.id,
                            vocabularyitems_common_art_producent.displayname,
                            persontermgroup_producent.forename,
                            persontermgroup_producent.surname,
                            vocabularyitems_common_producent.displayname,
                            vocabularyitems_common_producent.description,
                            smkstructureddatesmkgroup_producent_birth.datesmkdisplaytext,
                            smkstructureddatesmkgroup_producent_death.datesmkdisplaytext,
                            smkstructureddatesmkgroup_producent_birth.datesmkdisplayengtext,
                            smkstructureddatesmkgroup_producent_death.datesmkdisplayengtext,
                            smkstructureddatesmkgroup_producent_birth.datesmkthirddateyear,
                            smkstructureddatesmkgroup_producent_death.datesmkthirddateyear,
                            object_hierarchy0.pos 
                      

        UNION
                 /* an organization */
                
                        SELECT

                        object_hierarchy0.objid AS objectid,
                        object_hierarchy0.pos,
                          
                        format ('orga;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;;--;%s' ,
                                vocabularyitems_common_art_producent.displayname,
                                org_name.termdisplayname,
                                
                                smkstructureddatesmkgroup_producent_org_creation.datesmkthirddateyear,
        
                                smkstructureddatesmkgroup_producent_org_creation.datesmkdisplaytext,
                                
                                smkstructureddatesmkgroup_producent_org_creation.datesmkdisplayengtext,
                                
                                smkstructureddatesmkgroup_producent_org_dissolution.datesmkthirddateyear,
        
                                smkstructureddatesmkgroup_producent_org_dissolution.datesmkdisplaytext,
                                
                                smkstructureddatesmkgroup_producent_org_dissolution.datesmkdisplayengtext
                         )
                           
                        AS producents_data

                        FROM public.object_hierarchy0

                        LEFT JOIN faobjectproductionpersongroup faobjectproductionpersongroup_producent  ON object_hierarchy0.primarytype_id = faobjectproductionpersongroup_producent.id                                         

                        LEFT JOIN public.organizations_common org_common ON org_common.refname = faobjectproductionpersongroup_producent.faobjectproductionperson
                        LEFT JOIN public.hierarchy hierarchy_org_name ON org_common.id = hierarchy_org_name.parentid AND hierarchy_org_name.primarytype = 'orgTermGroup'
                        LEFT JOIN public.orgtermgroup org_name ON hierarchy_org_name.id = org_name.id

                        /*  name  */
                        RIGHT JOIN public.hierarchy hierarchy_producent_1 ON org_common.id = hierarchy_producent_1.parentid AND hierarchy_producent_1.primarytype = 'orgTermGroup' AND hierarchy_producent_1.pos = 0
                        LEFT JOIN public.persontermgroup persontermgroup_producent ON persontermgroup_producent.id = hierarchy_producent_1.id

                        /*  creation and dissolution date */
                        LEFT JOIN public.hierarchy hierarchy_producent_2 ON org_common.id = hierarchy_producent_2.parentid AND hierarchy_producent_2.name = 'organizations_smk:smkFoundingDateGroup'
                        LEFT JOIN public.smkstructureddatesmkgroup smkstructureddatesmkgroup_producent_org_dissolution ON smkstructureddatesmkgroup_producent_org_dissolution.id = hierarchy_producent_2.id
                        LEFT JOIN public.hierarchy hierarchy_producent_3 ON org_common.id  = hierarchy_producent_3.parentid AND hierarchy_producent_3.name = 'organizations_smk:smkDissolutionDateGroup'
                        LEFT JOIN public.smkstructureddatesmkgroup smkstructureddatesmkgroup_producent_org_creation ON smkstructureddatesmkgroup_producent_org_creation.id = hierarchy_producent_3.id

                        /* role  */
                        LEFT JOIN public.vocabularyitems_common vocabularyitems_common_art_producent ON faobjectproductionpersongroup_producent.faobjectproductionpersonrole = vocabularyitems_common_art_producent.refname

                        WHERE object_hierarchy0.primarytype = 'faObjectProductionPersonGroup'                 
                                AND object_hierarchy0.csid = '${objects.csid}'  

                        GROUP BY
                                objectid,
                                org_name.termdisplayname,
                                org_common.foundingplace,
                                object_hierarchy0.pos,
                                vocabularyitems_common_art_producent.displayname,
                                smkstructureddatesmkgroup_producent_org_creation.datesmkdisplaytext,
                                smkstructureddatesmkgroup_producent_org_dissolution.datesmkdisplaytext,
                                smkstructureddatesmkgroup_producent_org_creation.datesmkdisplayengtext,
                                smkstructureddatesmkgroup_producent_org_dissolution.datesmkdisplayengtext,
                                smkstructureddatesmkgroup_producent_org_creation.datesmkthirddateyear,
                                smkstructureddatesmkgroup_producent_org_dissolution.datesmkthirddateyear                                    
        
        
        ) AS sub_producent

  GROUP BY objectid             

) AS producent

ON collectionobjects_common.id = producent.objectid

/* - titles -*/
        /* all titles*/
LEFT JOIN(
        SELECT
        sub_title.objid as objid,
        string_agg(sub_title.title_all,';-;') AS title_all

        FROM(
                SELECT
                object_hierarchy0.objid AS objid,
                string_agg(                        
                         format('%s;--;%s;--;%s;--;%s',                                
                                smktitlegroup.smktitle,
                                smktitlegroup.smktitlenote,
                                smktitlegroup.smktitlelanguage,
                                title_translate.title_translate),                                        
                        ';-;') 
                 AS title_all

                FROM public.object_hierarchy0
        
                LEFT JOIN smktitlegroup ON object_hierarchy0.primarytype_id = smktitlegroup.id

                LEFT JOIN(                                
                                SELECT 
                                parentid,                                
                                string_agg(title_translate, ';---;') AS title_translate
                                
                                FROM(
                                        SELECT
                                        hierarchy_title_translate.parentid,                                                   
                                        
                                        string_agg(
                                                format('%s;-v;%s',
                                                smktitletranslationsubgroup.smktitletranslation,
                                                smktitletranslationsubgroup.smktitletranslationlanguage
                                                ),                                        
                                        ';---;')  AS title_translate,
                                        
                                        string_agg(hierarchy_title_translate.pos,'xxx')
                                
                                        FROM public.object_hierarchy0
                                        
                                        LEFT JOIN public.hierarchy hierarchy_title_translate ON object_hierarchy0.primarytype_id = hierarchy_title_translate.parentid                
                                        LEFT JOIN public.smktitletranslationsubgroup smktitletranslationsubgroup ON smktitletranslationsubgroup.id = hierarchy_title_translate.id 
                                
                                        WHERE object_hierarchy0.primarytype = 'smkTitleGroup'                 
                                                AND object_hierarchy0.csid = '${objects.csid}'                                         
                                
                                        GROUP BY
                                                hierarchy_title_translate.parentid,
                                                hierarchy_title_translate.pos
                                                
                                        ORDER BY                                          
                                                 hierarchy_title_translate.parentid,
                                                 hierarchy_title_translate.pos ASC
                                ) AS sub_translate
                                
                                GROUP BY parentid                                

                ) AS title_translate ON object_hierarchy0.primarytype_id = title_translate.parentid 
      
                WHERE object_hierarchy0.primarytype = 'smkTitleGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'  
        
                GROUP BY
                        object_hierarchy0.objid,
                        object_hierarchy0.pos
                
                ORDER BY object_hierarchy0.pos ASC
                                      
        ) AS sub_title
        
        GROUP BY objid

) AS title_all

ON collectionobjects_common.id = title_all.objid

/* - dimensions -*/

LEFT JOIN (

     SELECT 
     sub_dim.objectid,
     string_agg(sub_dim.meas_all, ';-;') AS meas_all
     
     FROM(                   
                SELECT
                object_hierarchy0.objid AS objectid,
                format('%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s',
                        measuredpartgroup_all.measuredpart,
                        string_agg(CAST (CAST (dimensionsubgroup_all_hojde.value AS NUMERIC ) AS TEXT),',') ,
                        string_agg(dimensionsubgroup_all_hojde.measurementunit,',') ,
                        string_agg(CAST (CAST (dimensionsubgroup_all_bredde.value AS NUMERIC ) AS TEXT),',') ,
                        string_agg(dimensionsubgroup_all_bredde.measurementunit,',') ,
                        string_agg(CAST (CAST (dimensionsubgroup_all_dybde.value AS NUMERIC ) AS TEXT),',') ,                                
                        string_agg(dimensionsubgroup_all_dybde.measurementunit,','),
                        string_agg(CAST (CAST (dimensionsubgroup_all_diameter.value AS NUMERIC ) AS TEXT),',') ,                                
                        string_agg(dimensionsubgroup_all_diameter.measurementunit,','),
                        string_agg(CAST (CAST (dimensionsubgroup_all_vaegt.value AS NUMERIC ) AS TEXT),',') ,                                
                        string_agg(dimensionsubgroup_all_vaegt.measurementunit,',')   
                ) AS meas_all
                
                
                FROM public.object_hierarchy0
                
                LEFT JOIN measuredpartgroup measuredpartgroup_all ON object_hierarchy0.primarytype_id = measuredpartgroup_all.id                                 

                LEFT JOIN public.hierarchy hierarchy_meas_all ON measuredpartgroup_all.id = hierarchy_meas_all.parentid AND hierarchy_meas_all.primarytype = 'dimensionSubGroup'

                LEFT JOIN public.dimensionsubgroup dimensionsubgroup_all_hojde ON hierarchy_meas_all.id = dimensionsubgroup_all_hojde.id AND dimensionsubgroup_all_hojde.dimension = 'hojde'
                LEFT JOIN public.dimensionsubgroup dimensionsubgroup_all_bredde ON hierarchy_meas_all.id = dimensionsubgroup_all_bredde.id AND dimensionsubgroup_all_bredde.dimension = 'bredde'
                LEFT JOIN public.dimensionsubgroup dimensionsubgroup_all_dybde ON hierarchy_meas_all.id = dimensionsubgroup_all_dybde.id AND dimensionsubgroup_all_dybde.dimension = 'dybde'
                LEFT JOIN public.dimensionsubgroup dimensionsubgroup_all_vaegt ON hierarchy_meas_all.id = dimensionsubgroup_all_vaegt.id AND dimensionsubgroup_all_vaegt.dimension = 'vaegt'
                LEFT JOIN public.dimensionsubgroup dimensionsubgroup_all_diameter ON hierarchy_meas_all.id = dimensionsubgroup_all_diameter.id AND dimensionsubgroup_all_diameter.dimension = 'diameter'

                WHERE object_hierarchy0.primarytype = 'measuredPartGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'  

                GROUP BY
                        object_hierarchy0.objid,
                        object_hierarchy0.primarytype_id,
                        measuredpartgroup_all.measuredpart                
                
        ) AS sub_dim   
        
        GROUP BY sub_dim.objectid                

) AS meas_all

ON collectionobjects_common.id = meas_all.objectid
                
/* - citations-*/

LEFT JOIN(

        SELECT
        sub_citations.objcsid  AS objectid,
        string_agg(
                format('%s;--;%s;--;%s;--;%s;--;%s',
                        initcap(sub_citations.agent),
                        sub_citations.title,
                        initcap(sub_citations.place),
                        sub_citations.date,
                        sub_citations.referencenote)
         , ';-;') AS citations
         
         FROM(

                SELECT
                object_hierarchy0.objid as objcsid,                       
                string_agg(smkcitationpublicationinfogroup.smkplace, ';--;') AS place,
                string_agg(smkstructureddatesmkgrouppublication.datesmkdisplaytext, ';--;') AS date,
                string_agg(citationtermgroup.termtitle, ';--;') AS title,
                string_agg(citationagentinfogroup.agent, ';--;') AS agent,
                referencegroup.referencenote AS referencenote                        

                FROM public.object_hierarchy0                
                LEFT JOIN referencegroup ON object_hierarchy0.primarytype_id = referencegroup.id                                   
                LEFT JOIN public.citations_common ON citations_common.refname = referencegroup.reference                        
                LEFT JOIN public.hierarchy hierarchy_citation_group ON hierarchy_citation_group.parentid = citations_common.id
                
                /* smkCitationPublicationInfoGroup */
                LEFT JOIN public.smkcitationpublicationinfogroup ON smkcitationpublicationinfogroup.id = hierarchy_citation_group.id AND hierarchy_citation_group.primarytype = 'smkCitationPublicationInfoGroup'
                LEFT JOIN public.hierarchy hierarchy_date_publication ON hierarchy_date_publication.parentid = hierarchy_citation_group.id
                LEFT JOIN public.smkstructureddatesmkgroup smkstructureddatesmkgrouppublication ON smkstructureddatesmkgrouppublication.id = hierarchy_date_publication.id
                
                /* citationTermGroup */
                LEFT JOIN public.citationtermgroup ON citationtermgroup.id = hierarchy_citation_group.id AND hierarchy_citation_group.primarytype = 'citationTermGroup'
                
                /* citationAgentInfoGroup */
                LEFT JOIN public.citationagentinfogroup ON citationagentinfogroup.id = hierarchy_citation_group.id AND hierarchy_citation_group.primarytype = 'citationAgentInfoGroup' AND hierarchy_citation_group.pos = 0

                WHERE object_hierarchy0.primarytype = 'referenceGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'

                GROUP BY
                        object_hierarchy0.objid,
                        citations_common.id,
                        referencegroup.referencenote
                ORDER BY date

            ) AS sub_citations
        
        GROUP BY
                sub_citations.objcsid

) AS citations

ON collectionobjects_common.id = citations.objectid

/* - all type signatures -*/
        LEFT JOIN(

                SELECT
                object_hierarchy0.objid AS objectid ,
                string_agg(
                        format('%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s;--;%s',
                        vocabularyitems_common_signature.displayname,
                        smktextualinscriptionsmkgroup.smkinscriptioncontentverso,
                        vocabularyitems_common_signature_position.displayname,
                        smktextualinscriptionsmkgroup.smkinscriptioncontentmethod,
                        smktextualinscriptionsmkgroup.smkinscriptioncontent,
                        smktextualinscriptionsmkgroup.smkinscriptioncontenttranslation,
                        smktextualinscriptionsmkgroup.smkinscriptioncontentinterpretation,
                        smkstructureddatesmkgroup.datesmkdisplaytext)
                 ,';-;')  AS betegnelser_data
                                  
                FROM public.object_hierarchy0
        
                LEFT JOIN smktextualinscriptionsmkgroup ON object_hierarchy0.primarytype_id = smktextualinscriptionsmkgroup.id                         
                LEFT JOIN public.vocabularyitems_common vocabularyitems_common_signature ON vocabularyitems_common_signature.refname = smktextualinscriptionsmkgroup.smkinscriptioncontenttype                        
                LEFT JOIN public.vocabularyitems_common vocabularyitems_common_signature_position ON vocabularyitems_common_signature_position.refname = smktextualinscriptionsmkgroup.smkinscriptioncontentposition                
                LEFT JOIN public.hierarchy hierarchy_smk_obj_prod_date_group ON smktextualinscriptionsmkgroup.id = hierarchy_smk_obj_prod_date_group.parentid AND hierarchy_smk_obj_prod_date_group.primarytype = 'smkStructuredDateSMKGroup'
                LEFT JOIN public.smkstructureddatesmkgroup ON smkstructureddatesmkgroup.id = hierarchy_smk_obj_prod_date_group.id


                WHERE object_hierarchy0.primarytype = 'smkTextualInscriptionSMKGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}'  

                GROUP BY
                        object_hierarchy0.objid

        ) AS betegnelser

        ON collectionobjects_common.id = betegnelser.objectid

/* - note til motiv -*/
        LEFT JOIN(

                SELECT

                object_hierarchy0.objid AS objectid,
                string_agg(smkcontentnotegroup.smkcontentnote,';-;') AS content_note

                FROM public.object_hierarchy0
                
                LEFT JOIN smkcontentnotegroup ON object_hierarchy0.primarytype_id = smkcontentnotegroup.id                         

                WHERE object_hierarchy0.primarytype = 'smkContentNoteGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}' 

                GROUP BY object_hierarchy0.objid

        ) AS contentnote

        ON collectionobjects_common.id = contentnote.objectid

/* - Litteraert forlaeg -*/
        LEFT JOIN(

                SELECT

                object_hierarchy0.objid AS objectid,
                string_agg(contenteventnamegroup.contenteventname,';-;') AS litt_references

                FROM public.object_hierarchy0
                
                LEFT JOIN contenteventnamegroup ON object_hierarchy0.primarytype_id = contenteventnamegroup.id                     

                WHERE object_hierarchy0.primarytype = 'contentEventNameGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}' 

                GROUP BY object_hierarchy0.objid

        ) AS littref

        ON collectionobjects_common.id = littref.objectid


/* - comments -*/
        LEFT JOIN(

                SELECT

                object_hierarchy0.objid AS objectid,
                string_agg(smkcomments.smkcommentsnote,';-;') AS comments
                
                FROM public.object_hierarchy0
                
                LEFT JOIN smkcomments ON object_hierarchy0.primarytype_id = smkcomments.id 

                WHERE object_hierarchy0.primarytype = 'smkComments'                 
                        AND object_hierarchy0.csid = '${objects.csid}' 

                GROUP BY object_hierarchy0.objid                              

        ) AS comments

        ON collectionobjects_common.id = comments.objectid

/* - note til elementer */
LEFT JOIN public.vocabularyitems_common vocabularyitems_format ON vocabularyitems_format.refname = collectionobjects_finearts.fadimensionsshape

/* - reference text -*/
        LEFT JOIN(

                SELECT
                object_hierarchy0.objid  AS objectid,
                string_agg(
                        format('%s;--;%s;--;%s',
                        vocabularyitems_common_ref_text.displayname,
                        smkreferencetext,
                        smkreferencetextlanguage  )
                 ,';-;') AS reference_text
                
                FROM public.object_hierarchy0
        
                LEFT JOIN smkreferencetextgroup ON object_hierarchy0.primarytype_id = smkreferencetextgroup.id 
                LEFT JOIN public.vocabularyitems_common vocabularyitems_common_ref_text ON vocabularyitems_common_ref_text.refname = smkreferencetextgroup.smkreferencetexttype
                
                WHERE object_hierarchy0.primarytype = 'smkReferenceTextGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}' 

                GROUP BY 
                        object_hierarchy0.objid
                  
        ) AS reference_text

        ON collectionobjects_common.id = reference_text.objectid

/* - vaerkstatus */
        LEFT JOIN(

                SELECT

                collectionobjects_common.id AS objectid,
                string_agg(vocabularyitems_common_status.displayname,';-;') AS vaerkstatus

                FROM public.collectionobjects_common collectionobjects_common

                INNER JOIN public.hierarchy hierarchy0 ON (collectionobjects_common.id = hierarchy0.id)
                
                LEFT JOIN public.collectionobjects_common_objectstatuslist status ON collectionobjects_common.id = status.id                 
                LEFT JOIN public.vocabularyitems_common vocabularyitems_common_status ON vocabularyitems_common_status.refname = status.item

                WHERE hierarchy0.name = '${objects.csid}'

                GROUP BY objectid

        ) AS vaerkstatus

        ON collectionobjects_common.id = vaerkstatus.objectid  

/* sikkerhedsstatus*/
        LEFT JOIN(
        
                SELECT

                collectionobjects_common.id AS objectid,
                string_agg(vocabularyitems_common_status.displayname,';-;') AS status

                FROM public.collectionobjects_common collectionobjects_common

                INNER JOIN public.hierarchy hierarchy0 ON (collectionobjects_common.id = hierarchy0.id)
                
                LEFT JOIN public.collectionobjects_finearts_falegalstatuses status ON collectionobjects_common.id = status.id                 
                LEFT JOIN public.vocabularyitems_common vocabularyitems_common_status ON vocabularyitems_common_status.refname = status.item

                WHERE hierarchy0.name = '${objects.csid}'

                GROUP BY objectid
        
        ) AS sikkerhed
        
        ON collectionobjects_common.id = sikkerhed.objectid  

/* topografisk motiv */
        LEFT JOIN(
        
                SELECT

                collectionobjects_common.id AS objectid,
                string_agg(placetermgroup.termdisplayname,';-;') AS topografisk_motiv

                FROM public.collectionobjects_common collectionobjects_common

                INNER JOIN public.hierarchy hierarchy0 ON (collectionobjects_common.id = hierarchy0.id)
                
                LEFT JOIN public.collectionobjects_common_contentplaces contentplaces ON collectionobjects_common.id = contentplaces.id                 
                LEFT JOIN public.places_common ON places_common.refname = contentplaces.item
                LEFT JOIN hierarchy hierarchy_places ON hierarchy_places.parentid = places_common.id
                LEFT JOIN public.placetermgroup ON placetermgroup.id = hierarchy_places.id

                WHERE hierarchy0.name = '${objects.csid}'

                GROUP BY objectid

        ) AS topografisk_motiv

        ON collectionobjects_common.id = topografisk_motiv.objectid  
        
/* portraetteret person */
        LEFT JOIN(
        
                SELECT

                collectionobjects_common.id AS objectid,
                string_agg(persontermgroup.termdisplayname,';-;') AS portrait_person


                FROM public.collectionobjects_common collectionobjects_common

                INNER JOIN public.hierarchy hierarchy0 ON (collectionobjects_common.id = hierarchy0.id)
                
                LEFT JOIN public.collectionobjects_common_contentpersons contentpersons ON collectionobjects_common.id = contentpersons.id                 
                LEFT JOIN public.persons_common ON persons_common.refname = contentpersons.item
                LEFT JOIN hierarchy hierarchy_persons ON hierarchy_persons.parentid = persons_common.id AND hierarchy_persons.pos = 0
                LEFT JOIN public.persontermgroup ON persontermgroup.id = hierarchy_persons.id

                WHERE hierarchy0.name = '${objects.csid}'
                

                GROUP BY objectid

        ) AS portrait_person

        ON collectionobjects_common.id = portrait_person.objectid     
        
/* - Ejer-deponent- */   
        LEFT JOIN(    
                SELECT
                
                collectionobjects_common.id AS objectid,
                string_agg(org_name.termdisplayname,';-;') AS ejer
                
                FROM public.collectionobjects_common collectionobjects_common
                
                INNER JOIN public.hierarchy hierarchy0 ON (collectionobjects_common.id = hierarchy0.id)
                
                LEFT JOIN public.collectionobjects_common_owners common_owners ON collectionobjects_common.id = common_owners.id                 
                LEFT JOIN public.organizations_common org_common ON org_common.refname = common_owners.item
                LEFT JOIN public.hierarchy hierarchy_org_name ON org_common.id = hierarchy_org_name.parentid AND hierarchy_org_name.primarytype = 'orgTermGroup'
                LEFT JOIN public.orgtermgroup org_name ON hierarchy_org_name.id = org_name.id
                
                WHERE hierarchy0.name = '${objects.csid}'
                
                GROUP BY objectid    
        ) AS ejer
        
       ON collectionobjects_common.id = ejer.objectid  

/* - description note (== vaerkstatus note)-*/

        LEFT JOIN(

                SELECT

                object_hierarchy0.objid AS objectid,
                string_agg(farelatedworklabelgroup.farelatedworklabel,';-;') AS farelatedworklabel

                FROM public.object_hierarchy0
                
                LEFT JOIN farelatedworklabelgroup ON object_hierarchy0.primarytype_id = farelatedworklabelgroup.id                 
                
                WHERE object_hierarchy0.primarytype = 'faRelatedWorkLabelGroup'                 
                        AND object_hierarchy0.csid = '${objects.csid}' 

                GROUP BY 
                        object_hierarchy0.objid

        ) AS farelatedworklabelgroup

        ON collectionobjects_common.id = farelatedworklabelgroup.objectid  

/* Other numbers */

        LEFT JOIN(

                SELECT

                object_hierarchy0.objid AS objectid,
                string_agg(format('%s;--;%s', vocabularyitems_common_vaerk.displayname, otherNumber.numbervalue), ';-;')  AS other_numbers              
                
                FROM public.object_hierarchy0
                
                LEFT JOIN othernumber ON object_hierarchy0.primarytype_id = othernumber.id                 
                LEFT JOIN public.vocabularyitems_common vocabularyitems_common_vaerk ON otherNumber.numbertype = vocabularyitems_common_vaerk.refname 
                
                WHERE object_hierarchy0.primarytype = 'otherNumber'                 
                        AND object_hierarchy0.csid = '${objects.csid}' 

                GROUP BY 
                        object_hierarchy0.objid

        ) AS other_numbers

        ON collectionobjects_common.id = other_numbers.objectid

/* - insurance currency -*/
        LEFT JOIN public.vocabularyitems_common vocabularyitems_common_insurance_curr ON vocabularyitems_common_insurance_curr.refname = collectionobjects_smk.smkinsurancevaluecurrency

/* - location -*/
        LEFT JOIN (

                SELECT
                location_sub.objectcsid,
                location_sub.location_date,
                location_sub.location_name,
                location_sub.location_note

                FROM public.collectionobjects_common collectionobjects_common

                INNER JOIN public.hierarchy hierarchy0 ON (collectionobjects_common.id = hierarchy0.id)

                LEFT JOIN (

                                SELECT

                                relations_common_movement.objectcsid AS objectcsid ,
                                loc_name.termdisplayname AS location_name,
                                to_char(movements.locationdate, 'DD-MM-YYYY') AS location_date,
                                movements.currentlocationnote AS location_note

                                FROM public.relations_common relations_common_movement

                                LEFT JOIN public.hierarchy hierarchy_movement ON relations_common_movement.subjectcsid= hierarchy_movement.name
                                RIGHT JOIN public.movements_common movements ON hierarchy_movement.id = movements.id AND movements.locationdate IS NOT NULL

                                /* location */
                                RIGHT JOIN public.locations_common loc_common ON movements.currentlocation = loc_common.refname
                                LEFT JOIN public.hierarchy hierarchy_loc_name ON loc_common.id = hierarchy_loc_name.parentid AND hierarchy_loc_name.primarytype = 'locTermGroup'
                                LEFT JOIN public.loctermgroup loc_name ON hierarchy_loc_name.id = loc_name.id

                                INNER JOIN public.misc misc ON (movements.id = misc.id AND misc.lifecyclestate != 'deleted')

                                WHERE 
                                        relations_common_movement.subjectdocumenttype='Movement' AND 
                                        relations_common_movement.objectcsid = '${objects.csid}' AND
                                        movements.movementreferencenumber LIKE 'PL%'

                                GROUP BY 
                                        relations_common_movement.objectcsid, 
                                        loc_name.termdisplayname, 
                                        movements.locationdate,
                                        movements.currentlocationnote

                        UNION

                                SELECT

                                relations_common_movement.objectcsid AS objectcsid ,
                                org_name.termdisplayname AS organization_name,
                                to_char(movements.locationdate, 'DD-MM-YYYY') AS location_date,
                                movements.currentlocationnote AS location_note

                                FROM public.relations_common relations_common_movement

                                LEFT JOIN public.hierarchy hierarchy_movement ON relations_common_movement.subjectcsid= hierarchy_movement.name
                                RIGHT JOIN public.movements_common movements ON hierarchy_movement.id = movements.id AND movements.locationdate IS NOT NULL

                                /* organization */
                                RIGHT JOIN public.organizations_common org_common ON movements.currentlocation = org_common.refname
                                LEFT JOIN public.hierarchy hierarchy_org_name ON org_common.id = hierarchy_org_name.parentid AND hierarchy_org_name.primarytype = 'orgTermGroup'
                                LEFT JOIN public.orgtermgroup org_name ON hierarchy_org_name.id = org_name.id

                                INNER JOIN public.misc misc ON (movements.id = misc.id AND misc.lifecyclestate != 'deleted')

                                WHERE 
                                        relations_common_movement.subjectdocumenttype='Movement' AND 
                                        relations_common_movement.objectcsid = '${objects.csid}' AND                                        
                                        movements.movementreferencenumber LIKE 'PL%'

                                GROUP BY 
                                        relations_common_movement.objectcsid, 
                                        org_name.termdisplayname, 
                                        movements.locationdate,
                                        movements.currentlocationnote

                ) AS location_sub

                ON hierarchy0.name = location_sub.objectcsid

                /* select only the last location / organization date for each object */
                RIGHT JOIN (
                        SELECT
                        to_char(MAX(movements.locationdate), 'DD-MM-YYYY') AS location_date,
                        relations_common_movement.objectcsid AS objcsid

                        FROM
                               public.relations_common relations_common_movement

                                LEFT JOIN public.hierarchy hierarchy_movement ON relations_common_movement.subjectcsid = hierarchy_movement.name
                                LEFT JOIN public.movements_common movements ON hierarchy_movement.id = movements.id

                                INNER JOIN public.misc misc ON (movements.id = misc.id AND misc.lifecyclestate != 'deleted')

                                WHERE 
                                        relations_common_movement.subjectdocumenttype='Movement' AND 
                                        relations_common_movement.objectcsid = '${objects.csid}' AND
                                        movements.movementreferencenumber LIKE 'PL%'

                         GROUP BY  objcsid
                ) AS last_date
                ON last_date.objcsid = location_sub.objectcsid AND last_date.location_date = location_sub.location_date

                WHERE hierarchy0.name = '${objects.csid}'

        ) AS location

        ON hierarchy0.name = location.objectcsid

/* - media -*/
        LEFT JOIN (

                SELECT

                relations_common_media.objectcsid AS objectcsid,
                array_agg(media_common.externalurl) AS externalurl

                FROM public.relations_common relations_common_media

                LEFT JOIN public.hierarchy hierarchy_media_2 ON relations_common_media.subjectcsid= hierarchy_media_2.name
                RIGHT JOIN public.misc miscmedia ON miscmedia.lifecyclestate != 'deleted' AND hierarchy_media_2.id= miscmedia.id
                RIGHT JOIN public.media_common media_common ON hierarchy_media_2.id= media_common.id 

                WHERE 
                        relations_common_media.subjectdocumenttype='Media' 
                        AND relations_common_media.objectcsid = '${objects.csid}'

                GROUP BY relations_common_media.objectcsid

        ) AS media

        ON hierarchy0.name = media.objectcsid

/* - related works' titles -*/
        LEFT JOIN (

                SELECT

                relations_common_related.objectcsid AS objectcsid,
                string_agg(
                        format('%s;--;%s', 
                                smktitle, 
                                related_object.objectnumber) 
                 ,';-;')AS title_dk

                FROM public.relations_common relations_common_related

                LEFT JOIN public.hierarchy hierarchy_related ON relations_common_related.subjectcsid= hierarchy_related.name 
                LEFT JOIN public.collectionobjects_common related_object ON related_object.id = hierarchy_related.id
                LEFT JOIN public.hierarchy hierarchy_title ON related_object.id = hierarchy_title.parentid 
                        AND hierarchy_title.primarytype = 'smkTitleGroup' 
                        AND hierarchy_title.pos = 0
                LEFT JOIN public.smktitlegroup smktitlegroup ON smktitlegroup.id = hierarchy_title.id 

                WHERE
                        relations_common_related.subjectdocumenttype='CollectionObject'
                        AND relations_common_related.relationshiptype='affects'
                        AND relations_common_related.objectcsid = '${objects.csid}'

                GROUP BY relations_common_related.objectcsid

        ) AS related_work

        ON hierarchy0.name = related_work.objectcsid

/* - multiple works -*/
        LEFT JOIN (

                SELECT

                sub_multi_work.objectcsid AS objectcsid,
                string_agg(sub_multi_work.multi_work_ref,';-;') AS multi_work_ref

                FROM(

                        SELECT

                        relations_common_related.objectcsid AS objectcsid,
                        format('%s;--;%s',
                                        smktitlegroup.smktitle,
                                        related_object.objectnumber) AS multi_work_ref

                        FROM public.relations_common relations_common_related

                        LEFT JOIN public.hierarchy hierarchy_related ON relations_common_related.subjectcsid= hierarchy_related.name
                        LEFT JOIN public.collectionobjects_common related_object ON related_object.id = hierarchy_related.id
                        LEFT JOIN public.hierarchy hierarchy_title ON related_object.id = hierarchy_title.parentid 
                                AND hierarchy_title.primarytype = 'smkTitleGroup'  
                                AND hierarchy_title.pos = 0
                        LEFT JOIN public.smktitlegroup smktitlegroup ON smktitlegroup.id = hierarchy_title.id

                        WHERE
                                relations_common_related.subjectdocumenttype = 'CollectionObject'
                                AND relations_common_related.relationshiptype='hasBroader'
                                AND relations_common_related.objectcsid = '${objects.csid}'

                       GROUP BY
                                relations_common_related.objectcsid,
                                related_object.objectnumber,
                                smktitlegroup.smktitle

                       ORDER BY CAST(split_part(related_object.objectnumber, '/', 2) AS TEXT)

                ) AS sub_multi_work

                GROUP BY sub_multi_work.objectcsid

        ) AS multi_work

        ON hierarchy0.name = multi_work.objectcsid

/* - related exhibitions -*/
        LEFT JOIN (

                 SELECT
                         objectcsid,
                         string_agg(exhibitionvenue,';-;') AS exhibitionvenue

                         FROM
                            (
                                SELECT

                                sub_sub_exhib.objectcsid AS objectcsid,
                                format('%s;--;%s;--;%s;--;%s',
                                exhibitiontitle,
                                sub_sub_exhib.place,
                                sub_sub_exhib.start_date_text,
                                sub_sub_exhib.end_date_text ) AS exhibitionvenue

                                FROM(

                                                SELECT
                                                                /*exhibitions (location)*/
                                                                relations_common_exhibition.objectcsid AS objectcsid,
                                                                exhibitiontitle,
                                                                loctermgroup.termdisplayname AS place,
                                                                smkstructureddatesmkgroup_exhib_start.datesmkdisplaytext AS start_date_text,
                                                                smkstructureddatesmkgroup_exhib_end.datesmkdisplaytext AS end_date_text,
                                                                smkstructureddatesmkgroup_exhib_start.datesmkearliestscalarvalue AS start_date

                                                                FROM public.relations_common relations_common_exhibition

                                                                LEFT JOIN public.hierarchy hierarchy_exhib ON relations_common_exhibition.subjectcsid= hierarchy_exhib.name
                                                                LEFT JOIN public.exhibitions_common exhibitions_common ON hierarchy_exhib.id= exhibitions_common.id
                                                                LEFT JOIN public.hierarchy hierarchy_exhib_group ON hierarchy_exhib_group.parentid = exhibitions_common.id

                                                                /*date from*/
                                                                LEFT JOIN public.hierarchy hierarchy_exhib_date_from ON hierarchy_exhib_date_from.parentid = hierarchy_exhib_group.id AND hierarchy_exhib_date_from.name = 'smkExhibitionDateFrom'
                                                                LEFT JOIN public.smkstructureddatesmkgroup smkstructureddatesmkgroup_exhib_start ON smkstructureddatesmkgroup_exhib_start.id = hierarchy_exhib_date_from.id

                                                                /*date to*/
                                                                LEFT JOIN public.hierarchy hierarchy_exhib_date_to ON hierarchy_exhib_date_to.parentid = hierarchy_exhib_group.id AND hierarchy_exhib_date_to.name = 'smkExhibitionDateTo'
                                                                LEFT JOIN public.smkstructureddatesmkgroup smkstructureddatesmkgroup_exhib_end ON smkstructureddatesmkgroup_exhib_end.id = hierarchy_exhib_date_to.id

                                                                /*venue (location)*/
                                                                LEFT JOIN public.smkexhibitionvenuegroup smkexhibitionvenuegroup ON smkexhibitionvenuegroup.id = hierarchy_exhib_group.id
                                                                RIGHT JOIN public.locations_common locations_common ON locations_common.refname = smkexhibitionvenuegroup.smkexhibitionvenue
                                                                LEFT JOIN public.hierarchy hierarchy_exhib_venue_group ON hierarchy_exhib_venue_group.id = locations_common.id AND hierarchy_exhib_venue_group.primarytype = 'Locationitem'
                                                                LEFT JOIN public.hierarchy hierarchy_exhib_venue ON hierarchy_exhib_venue_group.id = hierarchy_exhib_venue.parentid AND hierarchy_exhib_venue.primarytype='locTermGroup'
                                                                LEFT JOIN public.loctermgroup loctermgroup ON hierarchy_exhib_venue.id = loctermgroup.id

                                                                WHERE relations_common_exhibition.subjectdocumenttype='Exhibition' 
                                                                AND relations_common_exhibition.objectcsid = '${objects.csid}'

                                                                GROUP BY
                                                                        relations_common_exhibition.objectcsid,
                                                                        exhibitions_common.id,
                                                                        loctermgroup.termdisplayname,
                                                                        smkstructureddatesmkgroup_exhib_start.datesmkdisplaytext,
                                                                        smkstructureddatesmkgroup_exhib_end.datesmkdisplaytext,
                                                                        smkstructureddatesmkgroup_exhib_start.datesmkearliestscalarvalue

                                                        UNION

                                                                /*exhibitions (organization)*/
                                                                SELECT

                                                                relations_common_exhibition.objectcsid AS objectcsid,
                                                                exhibitiontitle,
                                                                orgtermgroup.termdisplayname AS place,
                                                                smkstructureddatesmkgroup_exhib_start.datesmkdisplaytext AS start_date_text,
                                                                smkstructureddatesmkgroup_exhib_end.datesmkdisplaytext AS end_date_text,
                                                                smkstructureddatesmkgroup_exhib_start.datesmkearliestscalarvalue AS start_date

                                                                FROM public.relations_common relations_common_exhibition

                                                                LEFT JOIN public.hierarchy hierarchy_exhib ON relations_common_exhibition.subjectcsid= hierarchy_exhib.name
                                                                LEFT JOIN public.exhibitions_common exhibitions_common ON hierarchy_exhib.id= exhibitions_common.id
                                                                LEFT JOIN public.hierarchy hierarchy_exhib_group ON hierarchy_exhib_group.parentid = exhibitions_common.id

                                                                /*date from*/
                                                                LEFT JOIN public.hierarchy hierarchy_exhib_date_from ON hierarchy_exhib_date_from.parentid = hierarchy_exhib_group.id AND hierarchy_exhib_date_from.name = 'smkExhibitionDateFrom'
                                                                LEFT JOIN public.smkstructureddatesmkgroup smkstructureddatesmkgroup_exhib_start ON smkstructureddatesmkgroup_exhib_start.id = hierarchy_exhib_date_from.id

                                                                /*date to*/
                                                                LEFT JOIN public.hierarchy hierarchy_exhib_date_to ON hierarchy_exhib_date_to.parentid = hierarchy_exhib_group.id AND hierarchy_exhib_date_to.name = 'smkExhibitionDateTo'
                                                                LEFT JOIN public.smkstructureddatesmkgroup smkstructureddatesmkgroup_exhib_end ON smkstructureddatesmkgroup_exhib_end.id = hierarchy_exhib_date_to.id

                                                                /*venue (organization)*/
                                                                LEFT JOIN public.smkexhibitionvenuegroup smkexhibitionvenuegroup ON smkexhibitionvenuegroup.id = hierarchy_exhib_group.id
                                                                RIGHT JOIN public.organizations_common organizations_common ON organizations_common.refname = smkexhibitionvenuegroup.smkexhibitionvenue
                                                                LEFT JOIN public.hierarchy hierarchy_exhib_venue_org_group ON hierarchy_exhib_venue_org_group.id = organizations_common.id AND hierarchy_exhib_venue_org_group.primarytype = 'OrganizationTenant5'
                                                                LEFT JOIN public.hierarchy hierarchy_exhib_venue_org ON hierarchy_exhib_venue_org_group.id = hierarchy_exhib_venue_org.parentid AND hierarchy_exhib_venue_org.primarytype='orgTermGroup'
                                                                LEFT JOIN public.orgtermgroup orgtermgroup ON hierarchy_exhib_venue_org.id = orgtermgroup.id

                                                                WHERE relations_common_exhibition.subjectdocumenttype='Exhibition' 
                                                                AND relations_common_exhibition.objectcsid = '${objects.csid}'

                                                                GROUP BY
                                                                        relations_common_exhibition.objectcsid,
                                                                        exhibitions_common.id, exhibitiontitle,
                                                                        orgtermgroup.termdisplayname,
                                                                        smkstructureddatesmkgroup_exhib_start.datesmkdisplaytext,
                                                                        smkstructureddatesmkgroup_exhib_end.datesmkdisplaytext,
                                                                        smkstructureddatesmkgroup_exhib_start.datesmkearliestscalarvalue
                                        ) AS sub_sub_exhib

                                GROUP BY
                                        sub_sub_exhib.objectcsid,
                                        exhibitiontitle,
                                        sub_sub_exhib.place,
                                        sub_sub_exhib.start_date_text,
                                        sub_sub_exhib.end_date_text,
                                        sub_sub_exhib.start_date

                                ORDER BY sub_sub_exhib.start_date ASC
                           )
                        AS sub_exhibitions

                        GROUP BY  sub_exhibitions.objectcsid

        )
        AS exhibitions

        ON hierarchy0.name = exhibitions.objectcsid

/* verifies that the objet is available*/
INNER JOIN public.collectionspace_core core ON core.id = collectionobjects_common.id
INNER JOIN public.misc misc ON misc.id = collectionobjects_common.id

WHERE core.tenantid = 5 AND misc.lifecyclestate != 'deleted' 
AND hierarchy0.name = '${objects.csid}'

GROUP BY

                acquisitions_common.originalobjectpurchasepricevalue    ,
                acquisitions_common.grouppurchasepricevalue,
                acquisitions_common.acquisitionnote  ,
                acquisitions_smk.smkacquistionsource   ,
                acquisitions_common.acquisitionreason ,
                
                betegnelser.betegnelser_data ,
                
                collectionobjects_common.numberofobjects,
                citations.citations,
                collectionobjects_common.objectnumber,
                collectionobjects_common.id,
                collectionobjects_common.physicaldescription,
                concepttermgroup.termdisplayname  ,
                collectionobjects_smk.smkinsurancedate  ,
                collectionobjects_smk.smkinsurancevalue  ,
                collectionobjects_smk.smksupport,
                collectionobjects_smk.smkposter,
                collectionobjects_smk.smkpostcard,
                collectionobjects_smk.smkmicroclimateframe,
                comments.comments ,
                contentnote.content_note  ,
                collectionobjects_finearts.faorientationremarks,
                collectionobjects_finearts.faorientationdescription,
                collectionobjects_finearts.famoulder,
                collectionobjects_finearts.fawatermark,               
                collectionobjects_finearts.fastatedescription, 
                collectionobjects_finearts.facopyrightstatement, 
                core.updatedat,             

                ejer.ejer,
                exhibitions.exhibitionvenue  ,

                faproductiontechniquegroup.faproductiontechnique   ,
                farelatedworklabelgroup.farelatedworklabel    ,

                hierarchy0.name,

                littref.litt_references  ,
                location.location_date ,
                location.location_name  ,
                location.location_note ,

                materiale.materiale,
                media.externalurl ,
                meas_all.meas_all,

                multi_work.multi_work_ref,

                objectproductionnote.objectproductionnote ,
                objbriefdescriptions.objbriefdescriptions ,
                objectophavsbeskrivelse.objectophavsbeskrivelse,
                other_numbers.other_numbers,
                object_all_production_dates.production_dates ,
                object_all_production_dates.datesmkearliestscalarvalue,
				object_all_production_dates.datesmklatestscalarvalue,
                
                proveniens.proveniens   ,
                portrait_person.portrait_person,
                producent.producents_data,
                production_place.production_place,

                related_work.title_dk,
                reference_text.reference_text    ,
                
                shape.displayname,
                smkstructureddatesmkgroup_obj_acq_date.datesmkdisplaytext ,
                smkstructureddatesmkgroup_obj_acq_date.datesmkdisplayengtext,
                smkstructureddatesmkgroup_obj_acq_date.datesmkearliestscalarvalue,
				smkstructureddatesmkgroup_obj_acq_date.datesmklatestscalarvalue,	
                sikkerhed.status,

                title_all.title_all,
                techniquearticle.techniquearticle,
                topografisk_motiv,

                vocabularyitems_common_purch_curr.displayname   ,
                vocabularyitems_common_group_purch_curr.displayname   ,
                vocabularyitems_common_acq.displayname    ,
                vocabularyitems_common_insurance_curr.displayname,
                vocabularyitems_format.displayname,
                vaerkstatus.vaerkstatus

ORDER BY collectionobjects_common.objectnumber        