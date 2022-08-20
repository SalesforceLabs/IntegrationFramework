<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <brand>
        <headerColor>#ED1809</headerColor>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <description>With the import monitoring app you can view the details of all processed import messages</description>
    <formFactors>Small</formFactors>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>true</isNavPersonalizationDisabled>
    <label>Import Monitoring</label>
    <navType>Console</navType>
    <tabs>Import_Message__c</tabs>
    <tabs>Import_Log__c</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>Import_Monitoring_UtilityBar</utilityBar>
    <workspaceConfig>
        <mappings>
            <fieldName>Import_Message__c</fieldName>
            <tab>Import_Log__c</tab>
        </mappings>
        <mappings>
            <tab>Import_Message__c</tab>
        </mappings>
    </workspaceConfig>
</CustomApplication>
