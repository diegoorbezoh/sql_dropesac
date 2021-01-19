--limpieza salesforce_visita_medico

update	salesforce_visita_medico
set		Geolocalizacion__c = REPLACE(REPLACE(Geolocalizacion__c,CHAR(10),''),CHAR(13),'')
go

update	salesforce_visita_medico
set		Material_Entregado__c = REPLACE(REPLACE(Material_Entregado__c,CHAR(10),''),CHAR(13),'')
go

update	salesforce_visita_medico
set		Trabajo_Programado__c = REPLACE(REPLACE(Trabajo_Programado__c,CHAR(10),''),CHAR(13),'')
go

update	salesforce_visita_medico
set		productos_promocionados__c = REPLACE(REPLACE(productos_promocionados__c,CHAR(10),''),CHAR(13),'')
go

update	salesforce_visita_medico
set		Tipo_de_Visita__c = REPLACE(REPLACE(Tipo_de_Visita__c,CHAR(10),''),CHAR(13),'')
go

update	salesforce_visita_medico
set		productos_oportunidad__c = REPLACE(REPLACE(productos_oportunidad__c,CHAR(10),''),CHAR(13),'')
go

update	salesforce_visita_medico
set		Finalidad_de_visita__c = REPLACE(REPLACE(Finalidad_de_visita__c,CHAR(10),''),CHAR(13),'')
go

update	salesforce_visita_medico
set		visitador_sub__c = REPLACE(REPLACE(visitador_sub__c,CHAR(10),''),CHAR(13),'')
go

update	salesforce_visita_medico
set		Entrego_Kit_de_proteccion__c = REPLACE(REPLACE(Entrego_Kit_de_proteccion__c,CHAR(10),''),CHAR(13),'')
go

update	salesforce_visita_medico
set		Elegir_Visita__c = REPLACE(REPLACE(Elegir_Visita__c,CHAR(10),''),CHAR(13),'')
go

update	salesforce_visita_medico
set		Medio_utilizado__c = REPLACE(REPLACE(Medio_utilizado__c,CHAR(10),''),CHAR(13),'')
go


update	salesforce_visita_medico
set		Geolocalizacion__c = replace(Geolocalizacion__c,',',';')
where	Geolocalizacion__c like '%,%'
go


