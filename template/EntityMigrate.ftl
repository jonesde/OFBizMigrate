<#--
Copyright 2011 Hemagenesis

Unlike Moqui and Apache OFBiz this is not open source or in the public
domain and may only be used under terms of a commercial license.
-->
<#assign typeMap = {
"blob":"binary-very-long",
"object":"binary-very-long",
"byte-array": "binary-very-long",
"date-time":"date-time", "date":"date", "time":"time",

"currency-amount":"currency-amount", "currency-precise":"currency-precise",
"fixed-point":"number-decimal", "floating-point":"number-float", "numeric":"number-integer",

"id":"id", "id-long":"id-long", "id-vlong":"id-long",
"indicator":"text-indicator", "very-short":"text-short", "short-varchar":"text-medium",
"long-varchar":"text-long", "very-long":"text-very-long",

"comment":"text-long", "description":"text-long", "name":"text-medium", "value":"text-long",
"credit-card-number":"text-long", "credit-card-date":"text-short", "email":"text-long", "url":"text-long",
"id-ne":"id", "id-long-ne":"id-long", "id-vlong-ne":"id-long", "tel-number":"text-medium"
}/>
<?xml version="1.0" encoding="UTF-8"?>
<entities xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://moqui.org/xsd/entity-definition-3.xsd">
<#visit entityXmlRoot/>
</entities>

<#macro @element>
    <!-- TODO: skipped element ${.node?node_name} -->
</#macro>
<#macro "entitymodel">
<#recurse>
</#macro>

<#macro "description">
<#--        <description>${.node}</description>-->
</#macro>

<#-- ========== entity and extend-entity ========== -->
<#macro "entity">
    <#-- TODO: read from entitygroup.xml file(s) to find value (if applicable) for group-name attribute -->
    <entity entity-name="${.node["@entity-name"]}" package="${.node["@package-name"]}"<#if .node["@table-name"]?has_content> table-name="${.node["@table-name"]}"</#if><#if .node["@sequence-bank-size"]?has_content> sequence-bank-size="${.node["@sequence-bank-size"]}"</#if><#if .node["@enable-lock"]?has_content> optimistic-lock="${.node["@enable-lock"]}"</#if><#if .node["@no-auto-stamp"]?has_content> no-update-stamp="${.node["@no-auto-stamp"]}"</#if><#if .node["@never-cache"]?if_exists == "true"> cache="never"</#if>>
        <#recurse>
    </entity>
</#macro>

<#macro "extend-entity">
    <#local entityName = .node["@entity-name"] />
    <#local packageName = packageMap.get(entityName)! />
    <extend-entity entity-name="${.node["@entity-name"]}" package="${packageName!}">
        <#recurse>
    </extend-entity>
</#macro>

<#macro "field">
    <#assign isPk = false>
    <#list .node?parent["prim-key"] as primKey><#if primKey["@field"] == .node["@name"]><#assign isPk = true></#if></#list>
            <field name="${.node["@name"]}" type="${typeMap[.node["@type"]]}"<#if isPk> is-pk="true"</#if><#if .node["@col-name"]?has_content> column-name="${.node["@col-name"]}"</#if><#if .node["@encrypt"]?has_content> encrypt="${.node["@encrypt"]}"</#if><#if .node["@enable-audit-log"]?has_content> enable-audit-log="${.node["@enable-audit-log"]}"</#if>>
            <#recurse>
        </field>
</#macro>
<#macro "prim-key"><#-- ignore, is handled in the field macro --></#macro>

<#macro "relation">
        <#local relEntityName = .node["@rel-entity-name"] />
        <#local packageName = packageMap.get(relEntityName)! />
        <#if packageName?has_content>
            <#local relEntityName = packageName + "." + relEntityName/>
        </#if>
        <relationship type="${.node["@type"]}"<#if .node["@fk-name"]?has_content> fk-name="${.node["@fk-name"]}"</#if><#if .node["@title"]?has_content> title="${.node["@title"]?cap_first}"</#if> related="${relEntityName}">
        <#recurse>
        </relationship>
</#macro>
<#macro "key-map">
            <key-map field-name="${.node["@field-name"]}"<#if .node["@rel-field-name"]?has_content> related="${.node["@rel-field-name"]}"</#if>/>
</#macro>

<#macro "index">
        <index name="${.node["@name"]}"<#if .node["@unique"]?has_content> unique="${.node["@unique"]}"</#if>>
            <#recurse>
        </index>
</#macro>
<#macro "index-field">
            <index-field name="${.node["@name"]}"/>
</#macro>

<#-- ========== view-entity ========== -->

<#macro "view-entity">
    <view-entity entity-name="${.node["@entity-name"]}" package="${.node["@package-name"]}"<#if .node["@never-cache"]?if_exists == "true"> cache="never"</#if>>
        <#recurse>
    </view-entity>
</#macro>
<#macro "member-entity">
    <#-- <#assign viewLink = null> -->
    <#list .node?parent["view-link"] as vl><#if vl["@rel-entity-alias"] == .node["@entity-alias"]>
        <#assign viewLink = vl><#break>
    </#if></#list>
        <member-entity entity-alias="${.node["@entity-alias"]}" entity-name="${.node["@entity-name"]}"<#if viewLink?exists> join-from-alias="${viewLink["@entity-alias"]}"<#if viewLink["@rel-optional"]?if_exists == "true"> join-optional="true"</#if></#if>>
        <#recurse>
        <#if viewLink?exists><#list viewLink["key-map"] as keyMap>
        <#visit keyMap>
        </#list></#if>
        <#if viewLink?exists><#list viewLink["entity-condition"] as entityCondition>
        <#visit entityCondition>
        </#list></#if>
        </member-entity>
</#macro>
<#macro "view-link"></#macro>


<#macro "alias-all">
        <alias-all entity-alias="${.node["@entity-alias"]}"<#if .node["@prefix"]?has_content> prefix="${.node["@prefix"]}"</#if>>
        <#recurse>
        </alias-all>
</#macro>
<#macro "exclude">
            <exclude field="${.node["@field"]}"/>
</#macro>
<#macro "alias">
        <alias entity-alias="${.node["@entity-alias"]}" name="${.node["@name"]}"<#if .node["@field"]?has_content> field="${.node["@field"]}"</#if><#if .node["@function"]?has_content> function="${.node["@function"]}"</#if>>
        <#recurse>
        </alias>
</#macro>
<#macro "complex-alias">
            <complex-alias>
                <!-- TODO: support complex-alias -->
                <#recurse>
            </complex-alias>
</#macro>

<#macro "entity-condition">
    <entity-condition>
        <!-- TODO: support entity-condition
        <xs:attribute name="filter-by-date" default="false">
            <xs:simpleType>
                <xs:restriction base="xs:token">
                    <xs:enumeration value="true"/>
                    <xs:enumeration value="false"/>
                    <xs:enumeration value="by-name"/>
                </xs:restriction>
            </xs:simpleType>
        </xs:attribute>
        <xs:attribute name="distinct" default="false" type="boolean"/>
        -->
        <#recurse>
    </entity-condition>
</#macro>
<#macro "condition-expr">
<#--    <econdition>-->
        <!-- TODO: support condition-expr -->
        <#recurse>
<#--    </econdition>-->
</#macro>
<#macro "condition-list">
    <econditions>
        <!-- TODO: support condition-list -->
        <#recurse>
    </econditions>
</#macro>
<#macro "having-condition-list">
    <having-econditions>
        <!-- TODO: support having-condition-list -->
        <#recurse>
    </having-econditions>
</#macro>
<#macro "order-by">
        <order-by field-name="${.node["@field-name"]}"/>
</#macro>