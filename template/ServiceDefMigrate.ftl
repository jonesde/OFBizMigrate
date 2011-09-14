<#--
Copyright 2011 Hemagenesis

Unlike Moqui and Apache OFBiz this is not open source or in the public
domain and may only be used under terms of a commercial license.
-->
<#assign typeMap = {
"bsh":"script", "groovy":"script", "jacl":"script", "javascript":"script", "jpython":"script", "simple":"script",
"entity-auto":"entity-auto", "interface":"interface", "java":"java"
}/>
<?xml version="1.0" encoding="UTF-8"?>
<services xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://moqui.org/xsd/service-definition-1.0.xsd">
<#visit serviceXmlRoot/>
</services>

<#macro @element>
    <!-- NOTE: skipped element ${.node?node_name} -->
</#macro>
<#macro "services">
<#recurse>
</#macro>

<#macro "description">
    <description>${.node}</description>
</#macro>

<#-- ========== service ========== -->
<#macro "service">
    <#assign serviceName = .node["@name"]>
    <#assign defaultEntityName = .node["@default-entity-name"]?if_exists>
    <#if defaultEntityName?has_content && serviceName?starts_with("create")>
        <#assign verb = "create"><#assign noun = defaultEntityName/>
    <#elseif defaultEntityName?has_content && serviceName?starts_with("update")>
        <#assign verb = "update"><#assign noun = defaultEntityName/>
    <#elseif defaultEntityName?has_content && serviceName?starts_with("delete")>
        <#assign verb = "delete"><#assign noun = defaultEntityName/>
    <#else>
        <#assign verb = serviceName>
    </#if>
    <service verb="${verb}"<#if noun?has_content> noun="${noun}"</#if> type="${typeMap[.node["@engine"]]!.node["@engine"]}"
            location="${.node["@location"]}"<#if .node["@invoke"]?has_content> method="${.node["@invoke"]}"</#if><#if .node["@auth"]?has_content> authenticate="${.node["@auth"]}"</#if><#if .node["@export"]?has_content> allow-remote="${.node["@export"]}"</#if><#if .node["@validate"]?has_content> validate="${.node["@validate"]}"</#if><#if .node["@use-transaction"]?if_exists == "false"> transaction="ignore"<#elseif .node["@require-new-transaction"]?if_exists == "true"> transaction="force-new"</#if><#if .node["@transaction-timeout"]?has_content> transaction-timeout="${.node["@transaction-timeout"]}"</#if>>
        <#recurse>
        <in-parameters>
            <#list .node["auto-attributes"] as aattrs><#if aattrs["@mode"] == "IN" || aattrs["@mode"] == "INOUT">
            <auto-parameters<#if aattrs["@entity-name"]?has_content> entity-name="${aattrs["@entity-name"]}"</#if><#if aattrs["@include"]?has_content> include="${aattrs["@include"]}"</#if> required="<#if !aattrs["@optional"]?exists || aattrs["@optional"] == "true">false<#else>true</#if>"<#if aattrs["@allow-html"]?has_content> allow-html="${aattrs["@allow-html"]}"</#if><#if aattrs["exclude"]?has_content>>
                <#list aattrs["exclude"] as exc>
                <exclude field-name="${exc["@field-name"]}"/>
                </#list>
            </auto-parameters><#else>/></#if>
            </#if></#list>
            <#list .node["attribute"] as attr><#if attr["@mode"] == "IN" || attr["@mode"] == "INOUT">
            <parameter name="${attr["@name"]}" type="${attr["@type"]}" required="<#if !attr["@optional"]?exists || attr["@optional"] == "true">false<#else>true</#if>"<#if attr["@default-value"]?has_content> default-value="${attr["@default-value"]}"</#if><#if attr["@allow-html"]?has_content> allow-html="${attr["@allow-html"]}"</#if>/>
            </#if></#list>
            <#list .node["override"] as attr><#if attr["@mode"] == "IN" || attr["@mode"] == "INOUT">
            <parameter name="${attr["@name"]}"<#if attr["@type"]?has_content> type="${attr["@type"]}"</#if><#if attr["@optional"]?has_content> required="<#if !attr["@optional"]?exists || attr["@optional"] == "true">false<#else>true</#if>"</#if><#if attr["@default-value"]?has_content> default-value="${attr["@default-value"]}"</#if><#if attr["@allow-html"]?has_content> allow-html="${attr["@allow-html"]}"</#if>/>
            </#if></#list>
        </in-parameters>
        <out-parameters>
            <#list .node["auto-attributes"] as aattrs><#if aattrs["@mode"] == "OUT" || aattrs["@mode"] == "INOUT">
            <auto-parameters<#if aattrs["@entity-name"]?has_content> entity-name="${aattrs["@entity-name"]}"</#if><#if aattrs["@include"]?has_content> include="${aattrs["@include"]}"</#if> required="<#if !aattrs["@optional"]?exists || aattrs["@optional"] == "true">false<#else>true</#if>"<#if aattrs["@allow-html"]?has_content> allow-html="${aattrs["@allow-html"]}"</#if><#if aattrs["exclude"]?has_content>>
                <#list aattrs["exclude"] as exc>
                <exclude field-name="${exc["@field-name"]}"/>
                </#list>
            </auto-parameters><#else>/></#if>
            </#if></#list>
            <#list .node["attribute"] as attr><#if attr["@mode"] == "OUT" || attr["@mode"] == "INOUT">
            <parameter name="${attr["@name"]}" type="${attr["@type"]}" required="<#if !attr["@optional"]?exists || attr["@optional"] == "true">false<#else>true</#if>"<#if attr["@default-value"]?has_content> default-value="${attr["@default-value"]}"</#if><#if attr["@allow-html"]?has_content> allow-html="${attr["@allow-html"]}"</#if>/>
            </#if></#list>
            <#list .node["override"] as attr><#if attr["@mode"] == "IN" || attr["@mode"] == "INOUT">
            <parameter name="${attr["@name"]}"<#if attr["@type"]?has_content> type="${attr["@type"]}"</#if><#if attr["@optional"]?has_content> required="<#if !attr["@optional"]?exists || attr["@optional"] == "true">false<#else>true</#if>"</#if><#if attr["@default-value"]?has_content> default-value="${attr["@default-value"]}"</#if><#if attr["@allow-html"]?has_content> allow-html="${attr["@allow-html"]}"</#if>/>
            </#if></#list>
        </out-parameters>
    </service>
</#macro>

<#macro "implements">
    <implements service=".node["@service"]"<#if .node["@optional"]?if_exists == "true"> required="false"</#if>/>
</#macro>
<#macro "attribute"><#-- do nothing, this is called explicitly --></#macro>
<#macro "override"><#-- do nothing, this is called explicitly --></#macro>
<#macro "auto-attributes"><#-- do nothing, this is called explicitly --></#macro>
