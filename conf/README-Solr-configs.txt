In:

  htrc-configs-docvals/conf/managed-schema

Replace the root element
  <schema ...

With:
41c41,43
< <schema name="default-config" version="1.6">
---
> <schema name="htrc-ef-docvals" version="1.6">
> <!-- based on _default from solr 8.4.1 -->

(change 8.4.1 to whatever newer version of Solr you are imprinting on)

And just before:
    <dynamicField name="*_i"  type="pint"    indexed="true"  stored="true"/>

Add in:
127a130,134
>     <!-- htrc-mod -->
>     <dynamicField name="*_htrctoken" type="htrcstrings"  indexed="true" stored="false" required="false" multiValued="true" />
>     <dynamicField name="*_htrctokentext" type="htrctext" indexed="true" stored="false" required="false" multiValued="true" />
>     <dynamicField name="*_htrcstring"  type="htrcstring"   indexed="true"  stored="false" />
>     <dynamicField name="*_htrcstrings" type="htrcstrings"  indexed="true"  stored="false" />
>

And just a bit furhter down, change:
134,135c141,142
<     <dynamicField name="*_t" type="text_general" indexed="true" stored="true" multiValued="false"/>
<     <dynamicField name="*_txt" type="text_general" indexed="true" stored="true"/>
---
>    <!--
>    <dynamicField name="*_t" type="text_general" indexed="true" stored="true" multiValued="false"/>
>    <dynamicField name="*_txt" type="text_general" indexed="true" stored="true"/>
>    -->
>    <!-- htrc: '*_t' was present in Solr6, but then was removed in Solr7, so manually added in for HTRC work
>	        It is now back in Solr8, but with multiValued="false" as an additinal parameter -->
>    <dynamicField name="*_t"   type="text_general" indexed="true" stored="true" multiValued="false"/>  <!-- htrc: not clear if multiValued needs to be false or true -->
>    <dynamicField name="*_txt" type="text_general" indexed="true" stored="false"/> <!-- htrc: is this change to stored="false" still relied upon anywhere? -->

Add in just above:
      <!-- This point type indexes the coordinates as separate fields (subFields)
      
500a480,496
>     <!-- htrc-mod -->
>     <!-- since fields of this type are by default not stored or indexed,
>          any data added to them will be ignored outright.  -->
>     <fieldType name="htrcstring"  stored="false" indexed="true" docValues="true" class="solr.StrField" /> <!-- htrc-docvals edit -->
>     <fieldType name="htrcstrings" stored="false" indexed="true" docValues="true" multiValued="true" class="solr.StrField" /> <!-- htrc-docvals edit -->
>
>     <fieldType name="htrctext" stored="false" indexed="true" docValues="false" multiValued="true" class="solr.TextField"> <!-- htrc-docvals issue -->
>       <analyzer type="query">
>       <tokenizer class="solr.WhitespaceTokenizerFactory"/>
>       <filter class="solr.LowerCaseFilterFactory"/>
>       </analyzer>
>       <analyzer type="select"> <!-- htrc: is this entry still used? -->
>       <tokenizer class="solr.WhitespaceTokenizerFactory"/>
>       <filter class="solr.LowerCaseFilterFactory"/>
>       </analyzer>
>     </fieldType>
>

====
In:

  htrc-config-docvals/conf/solrconfig.xml

Change:
  <maxBooleanClauses>${solr.max.booleanClauses:1024}</maxBooleanClauses>  
to
  <maxBooleanClauses>${solr.max.booleanClauses:4096}</maxBooleanClauses>
====

