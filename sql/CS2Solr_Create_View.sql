DROP VIEW object_hierarchy0;

CREATE VIEW object_hierarchy0 AS
SELECT
        collectionobjects_common.id AS objid,
        hierarchy0.name AS csid,
        hierarchy_obj_fab.primarytype,
        hierarchy_obj_fab.id AS primarytype_id,
        hierarchy_obj_fab.pos AS pos
FROM public.collectionobjects_common collectionobjects_common        
INNER JOIN public.hierarchy hierarchy0 ON collectionobjects_common.id = hierarchy0.id
LEFT JOIN public.hierarchy hierarchy_obj_fab ON collectionobjects_common.id = hierarchy_obj_fab.parentid

--WHERE hierarchy0.name = '77d9d483-7da1-4e11-af57-5aafd6a31174'   