Solr Schema
===========

The Solr search interface to the 5.5+ billion page Part-of-Speech
(POS) and language tagged HTRC Extracted Features dataset can be found
at:

  https://solr1.ischool.illinois.edu/solr-ef/index.html

This document details the Solr schema developed for this.  It makes
heavy use of dynamic fields.  First we described the full-text
indexing part, and then move onto how volume-level metadata is blended
in with this.

1. Indexing the language and POS tagged full text
=================================================

In terms of how the Solr index is structured, we take the default
schema that ships with Solr 6, and make the additions/changes detailed
below:

At the base level we have the types:

   <fieldType name="htrcstring"  stored="false" indexed="true" docValues="false" class="solr.StrField" />

   <fieldType name="htrcstrings" stored="false" indexed="true" docValues="false" multiValued="true" class="solr.StrField" />

Given the volume of text on the page that is being pushed through, we
have opted not to have these stored.

On top of this, we then have the dynamicField:

  <dynamicField name="*_htrctoken" type="htrcstrings" indexed="true" stored="false" required="false" multiValued="true" />

No stemming, but text is case-folded.

For every page in the JSON Extracted Features files, the text is
tagged with language (determined by an OpenNLP pass earlier in the
production of these JSON files).  In the Solr index built, we use this
to map to language specific fields:

  fr_htrctokentext
  es_htrctokentext
  ...

In the case of 6 languages, OpenNLP models existed for Part-of-Speech
tagging, which were also run against the pages of text.  The languages
were:

  English, German, Portuguese, Danish, Dutch, Swedish

For JSON Extracted Feature files with pages in the above 6 languages,
the individual words are further tagged with POS information.  This
information is mapped into language+POS fields such as:

  en_NOUN_htrctokentext
  en_ADJ_htrctokentext
  ...

  de_NOUN_htrctokentext
  ...

The OpenNLP tagger for language uses the 2-letter ISO standard for languages.

  https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2

In our fields we make the 2-letter codes lowercase.  The OpenNLP
language models used extend the country codes (slightly) to use zh-cn
and zh-tw respectively for mainland-China and Taiwanese.  From what we
can tell this is actually indicative of whether the classified text is
simplified or traditional Chinese text.

We follow the universal POS tag set developed by Google:

 https://github.com/slavpetrov/universal-pos-tags

2. Volme-level Metadata
=======================

The Extracted Features JSON files also include volume level metadata.
This is mapped to a variety of fields to support various features in
the Solr-EF search interface.  The key definitions are:

  <dynamicField name="*_t"   type="text_general" indexed="true" stored="true"/>
  <dynamicField name="*_txt" type="text_general" indexed="true" stored="false"/> <!-- note, not stored -->
  <dynamicField name="*_s"  type="string"  indexed="true"  stored="true" />
  <dynamicField name="*_ss" type="strings"  indexed="true"  stored="true"/>

So:

  '_t' when we need things to be tokenized and stored

  '_txt' when we need things to be tokenized, but not stored

  '_s' and '_ss' when we do not want it tokenized (see facets below);
  former for when there is a single term, latter for multiple terms.


2.1 Straight out volume-level metadata search
=============================================


To support volume-level search, we map metadata to fields such as:

  title_t
  genre_t
   ...

We store these values in the index, so the interface can retrieve
these values to present to the user in the results set that is
produced.


2.2. Combined volume-level metadata and page-level text search
==============================================================


To support this sort of combined search, every page to a volume also
indexes what its volume-level metadata is.  We map these to non-stored
values:

  volumetitle_txt
  volumegenre_txt
  ...

2.3. Facets
===========


To implement faceted search (e.g., filter by genre), we want
non-tokenized volume-level fields.  These go by the form:

  rightsAttribute_s
  genre_ss

The '_s' is for when there can be only one value (such as its
copyright status), and '_ss' when there can be more than one value (as
in genre).  We want it to be a string rather than tokenized text so,
for example, restricting a facet to 'fiction' doesn't trigger matches
in items tagged as 'non fiction'.

You will find some examples of direct calls to the Solr Search API
that pull all this together at:

  https://solr1.ischool.illinois.edu/solr-ef/solr-ef-query-api.txt
