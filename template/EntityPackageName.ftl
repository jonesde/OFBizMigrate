<#visit entityXmlRoot/>
<#macro @element>
    <!-- TODO: skipped element ${.node?node_name} -->
</#macro>
<#macro "entitymodel">
<#recurse>
</#macro>

<#macro "entity">
    <#-- TODO: read from entitygroup.xml file(s) to find value (if applicable) for group-name attribute -->
    <#local packageMap = ec.getContext().packageMap />
    <#if !packageMap.get(.node["@entity-name"])?has_content>
        ${packageMap.put(.node["@entity-name"], .node["@package-name"])!}
    </#if>
<#--${ec.getContext().packageMap}-->
</#macro>