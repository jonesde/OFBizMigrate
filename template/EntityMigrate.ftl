<#-- Copyright 2011 by David E. Jones -->

<#assign typeMap = {
"blob":"binary-very-long",
"date-time":"date-time", "date":"date", "time":"time",

"currency-amount":"currency-amount", "currency-precise":"currency-precise",
"fixed-point":"number-decimal", "floating-point":"number-float", "numeric":"number-integer",

"id":"id", "id-long":"id-long", "id-vlong":"id-very-long",
"indicator":"text-indicator", "very-short":"text-short", "short-varchar":"text-medium",
"long-varchar":"text-long", "very-long":"text-very-long",

"comment":"text-long", "description":"text-long", "name":"text-medium", "value":"text-long",
"credit-card-number":"text-long", "credit-card-date":"text-short", "email":"text-long", "url":"text-long",
"id-ne":"id", "id-long-ne":"id-long", "id-vlong-ne":"id-very-long", "tel-number":"text-medium"
}/>


<#macro "entitymodel">
<#recurse>
</#macro>

<#macro "description">
    <description>${.node}</description>
</#macro>

<#-- ========== entity and extend-entity ========== -->
<#macro "entity">
    <!-- TODO: read from entitygroup.xml file(s) to find value (if applicable) for group-name attribute -->
    <entity entity-name="${.node["@entity-name"]}" package-name="${.node["@package-name"]}"<#if .node["@table-name"]?has_content> table-name="${.node["@table-name"]}"</#if><#if .node["@sequence-bank-size"]?has_content> sequence-bank-size="${.node["@sequence-bank-size"]}"</#if><#if .node["@enable-lock"]?has_content> optimistic-lock="${.node["@enable-lock"]}"</#if><#if .node["@no-auto-stamp"]?has_content> no-update-stamp="${.node["@no-auto-stamp"]}"</#if><#if .node["@never-cache"]?if_exists == "true"> cache="never"</#if>>
        <#recurse>
    </entity>
</#macro>

<#macro "extend-entity">
    <extend-entity entity-name="${.node["@entity-name"]}">
        <#recurse>
    </extend-entity>
</#macro>

<#macro "field">
    <#assign isPk = false>
    <#list .node?parent["prim-key"] as primKey><#if primKey["@field"] == .node["@name"]><#assign isPk = true></#if></#list>
    <field name="${.node["@name"]}" type="${typeMap[.node["@type"]]}"<#if isPk> is-pk="true"</#if><#if .node["@col-name"]?has_content> column-name="${.node["@col-name"]}"</#if><#if .node["@encrypt"]?has_content> encrypt="${.node["@encrypt"]}"</#if><#if .node["@enable-audit-log"]?has_content> enable-audit-log="${.node["@enable-audit-log"]}"</#if>/>
</#macro>
<#macro "prim-key"><#-- ignore, is handled in the field macro --></#macro>

<#macro "relation">
    <relationship type="${.node["@type"]}" fk-name="${.node["@fk-name"]}"<#if .node["@title"]?has_content> title="${.node["@title"]}"</#if> related-entity-name="${.node["@rel-entity-name"]}">
        <#recurse>
    </relationship>
</#macro>
<#macro "key-map">
    <key-map field-name="${.node["@field-name"]}" related-field-name="${.node["@rel-field-name"]}"/>
</#macro>

<#macro "index">
    <index name="${.node["@name"]}" unique="${.node["@unique"]}">
        <#recurse>
    </index>
</#macro>
<#macro "index-field">
    <index-field name="${.node["@name"]}"/>
</#macro>

<#-- ========== view-entity ========== -->

<#macro "view-entity">
    <view-entity entity-name="${.node["@entity-name"]}" package-name="${.node["@package-name"]}"<#if .node["@never-cache"]?if_exists == "true"> cache="never"</#if>>
        <#recurse>
    </view-entity>
</#macro>

                <xs:element maxOccurs="unbounded" ref="member-entity"/>
                <xs:element minOccurs="0" maxOccurs="unbounded" ref="alias-all"/>
                <xs:element minOccurs="0" maxOccurs="unbounded" ref="alias"/>
                <xs:element minOccurs="0" maxOccurs="unbounded" ref="view-link"/>
                <xs:element minOccurs="0" maxOccurs="unbounded" ref="relation"/>
                <xs:element minOccurs="0" ref="entity-condition"/>
