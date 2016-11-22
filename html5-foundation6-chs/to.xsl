<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   exclude-result-prefixes="tei html teidocx"
   version="2.0">

   <!-- import base conversion style -->
   <!-- <xsl:import href="../../../html5/html5.xsl"/>
   <xsl:import href="../../../html5/microdata.xsl"/> -->
   
   <!-- change path to your TEI Stylesheets https://github.com/TEIC/Stylesheets/blob/master/html5/html5.xsl -->
   <xsl:import href="../../Stylesheets-master/html5/html5.xsl"/>
   <!-- change path to your TEI Stylesheets https://github.com/TEIC/Stylesheets/blob/master/html5/microdata.xsl -->
   <xsl:import href="../../Stylesheets-master/html5/microdata.xsl"/>
   
   <xsl:import href="new-html_figures.xsl"/>
   <xsl:import href="new-html_core.xsl"/>
   
   <xsl:import href="header.xsl"/>
   <xsl:import href="divGen.xsl"/>
   
   <xsl:import href="my-html_param.xsl"/>
   <xsl:import href="my-html_core.xsl"/>
   <xsl:import href="bibliography.xsl"/>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>TEI stylesheet for making HTML5 output (Zurb Foundation 6 http://foundation.zurb.com/sites/docs/).</p>
         <p>This software is dual-licensed:
            
            1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
            Unported License http://creativecommons.org/licenses/by-sa/3.0/ 
            
            2. http://www.opensource.org/licenses/BSD-2-Clause
            
            
            
            Redistribution and use in source and binary forms, with or without
            modification, are permitted provided that the following conditions are
            met:
            
            * Redistributions of source code must retain the above copyright
            notice, this list of conditions and the following disclaimer.
            
            * Redistributions in binary form must reproduce the above copyright
            notice, this list of conditions and the following disclaimer in the
            documentation and/or other materials provided with the distribution.
            
            This software is provided by the copyright holders and contributors
            "as is" and any express or implied warranties, including, but not
            limited to, the implied warranties of merchantability and fitness for
            a particular purpose are disclaimed. In no event shall the copyright
            holder or contributors be liable for any direct, indirect, incidental,
            special, exemplary, or consequential damages (including, but not
            limited to, procurement of substitute goods or services; loss of use,
            data, or profits; or business interruption) however caused and on any
            theory of liability, whether in contract, strict liability, or tort
            (including negligence or otherwise) arising in any way out of the use
            of this software, even if advised of the possibility of such damage.
         </p>
         <p>Andrej Pančur, Institute for Contemporary History</p>
         <p>Copyright: 2013, TEI Consortium</p>
      </desc>
   </doc>
   
   <xsl:output method="xhtml" omit-xml-declaration="yes" indent="no" encoding="UTF-8"/>
   <xsl:param name="doctypeSystem"></xsl:param>
   
   <!-- prevod: opombe, slike ipd. Pobere iz ../i18n.xml -->
   <xsl:param name="documentationLanguage">en</xsl:param>
   
   <!-- verbose - izpišejo se pojansila; koristno v času kodiranja (true), drugače odstrani oz. false -->
   <xsl:param name="verbose">false</xsl:param>
   
   <xsl:param name="outputDir">rezultat</xsl:param>
   <xsl:param name="splitLevel">0</xsl:param>
   <xsl:param name="STDOUT">false</xsl:param>
   
   <!-- head v drugem div je h3 itn. Glej še spodaj template stdheader -->
   <xsl:param name="divOffset">2</xsl:param>
   
   <xsl:template name="stdfooter"/>
   
   <xsl:param name="institution"></xsl:param>
   <xsl:param name="footnoteBackLink">true</xsl:param>
   <xsl:param name="generateParagraphIDs">true</xsl:param>
   <xsl:param name="numberBackHeadings"></xsl:param>
   <xsl:param name="numberFigures">true</xsl:param>
   <xsl:param name="numberFrontTables">true</xsl:param>
   <xsl:param name="numberHeadings">true</xsl:param>
   <xsl:param name="numberParagraphs">true</xsl:param>
   <xsl:param name="numberTables">true</xsl:param>
   
   <!-- pobrano iz Stylesheets-master/common/functions.xsl  -->
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[localisation] dummy template for overriding in a local system<param name="word">the word(s) to translate</param>
      </desc>
   </doc>
   <xsl:variable name="myi18n" select="document('../myi18n.xml',document(''))"/>
   <xsl:template name="myi18n">
      <xsl:param name="word"/>
      <xsl:variable name="Word">
         <xsl:value-of select="normalize-space($word)"/>
      </xsl:variable>
      <xsl:for-each select="$myi18n">
         <xsl:choose>
            <xsl:when test="key('KEYS',$Word)/text[@xml:lang=$documentationLanguage]">
               <xsl:value-of select="key('KEYS',$Word)/text[@xml:lang=$documentationLanguage]"/>
            </xsl:when>
            <xsl:when test="key('KEYS',$Word)/text[@lang3=$documentationLanguage]">
               <xsl:value-of select="key('KEYS',$Word)/text[lang3=$documentationLanguage]"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="key('KEYS',$Word)/text[@xml:lang='sl']"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template name="headHook">
      <meta http-equiv="x-ua-compatible" content="ie=edge"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <meta name="description"
         content="{$description}"/>
      <meta name="keywords" content="{$keywords}"/>
   </xsl:template>
   <xsl:param name="cssFile">
      <xsl:value-of select="concat($path-general,'publikacije/themes/foundation/6/css/foundation.min.css')"/>
   </xsl:param>
   <xsl:param name="cssPrintFile"></xsl:param>
   <xsl:param name="cssSecondaryFile">
      <xsl:value-of select="concat($path-general,'publikacije/themes/css/foundation/6/sistory.css')"/>
   </xsl:param>
   <xsl:template name="cssHook">
      <link href="http://cdnjs.cloudflare.com/ajax/libs/foundicons/3.0.0/foundation-icons.min.css" rel="stylesheet" type="text/css" />
      <link href="{concat($path-general,'publikacije/themes/css/plugin/TipueSearch/3.1/moj_class_tipuesearch.css')}"  rel="stylesheet" type="text/css" />
   </xsl:template>
   <xsl:template name="javascriptHook">
      <script src="{concat($path-general,'publikacije/themes/foundation/6/js/vendor/jquery.js')}"></script>
      <!-- za iskalnik tipue -->
      <xsl:if test="//tei:divGen[@type='search']">
         <!-- v spodnjem js je shranjena vsebina za iskanje -->
         <script src="tipuesearch_content.js"></script>
         <script src="{concat($path-general,'publikacije/themes/plugin/TipueSearch/3.1/tipuesearch/tipuesearch_set.js')}"></script>
         <script src="{concat($path-general,'publikacije/themes/js/plugin/TipueSearch/3.1/moj_class_tipuesearch.js')}"></script>
      </xsl:if>
      <!-- za back-to-top je drugače potrebno dati jquery, vendar sedaj ne rabim dodajati jquery kodo, ker je že vsebovana zgoraj -->
   </xsl:template>
   <xsl:template name="bodyEndHook">
      <script src="{concat($path-general,'publikacije/themes/foundation/6/js/vendor/what-input.js')}"></script>
      <script src="{concat($path-general,'publikacije/themes/foundation/6/js/vendor/foundation.min.js')}"></script>
      <script src="{concat($path-general,'publikacije/themes/foundation/6/js/app.js')}"></script>
      <!-- back-to-top -->
      <script src="{concat($path-general,'publikacije/themes/js/plugin/back-to-top/back-to-top.js')}"></script>
   </xsl:template>
   
   <!-- naredi index.html datoteko -->
   <xsl:template name="pageLayoutSimple">
      <!-- vključimo HTML5 deklaracijo -->
      <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
      <html class="no-js">
         <xsl:call-template name="addLangAtt"/>
         <xsl:variable name="pagetitle">
            <xsl:sequence select="tei:generateTitle(.)"/>
         </xsl:variable>
         <xsl:sequence select="tei:htmlHead($pagetitle, 3)"/>
         <body class="simple" id="TOP">
            <xsl:copy-of select="tei:text/tei:body/@unload"/>
            <xsl:copy-of select="tei:text/tei:body/@onunload"/>
            <xsl:call-template name="bodyMicroData"/>
            <xsl:call-template name="bodyJavascriptHook"/>
            <xsl:call-template name="bodyHook"/>
            <!-- začetek vsebine -->
            <div class="column row">
               <!-- vstavim svoj header -->
               <xsl:call-template name="html-header">
                  <xsl:with-param name="thisChapter-id">index</xsl:with-param>
               </xsl:call-template>
               <xsl:if test="not(tei:text/tei:front/tei:titlePage)">
                  <div class="stdheader autogenerated">
                     <xsl:call-template name="stdheader">
                        <xsl:with-param name="title">
                           <xsl:sequence select="tei:generateTitle(.)"/>
                        </xsl:with-param>
                     </xsl:call-template>
                  </div>
               </xsl:if>
               <xsl:comment>TEI  front matter </xsl:comment>
               <xsl:apply-templates select="tei:text/tei:front"/>
               <xsl:if
                  test="$autoToc = 'true' and (descendant::tei:div or descendant::tei:div1) and not(descendant::tei:divGen[@type = 'toc'])">
                  <h2>
                     <xsl:sequence select="tei:i18n('tocWords')"/>
                  </h2>
                  <xsl:call-template name="mainTOC"/>
               </xsl:if>
               <xsl:choose>
                  <xsl:when test="tei:text/tei:group">
                     <xsl:apply-templates select="tei:text/tei:group"/>
                  </xsl:when>
                  <xsl:when test="tei:match(@rend, 'multicol')">
                     <table>
                        <tr>
                           <xsl:apply-templates select="tei:text/tei:body"/>
                        </tr>
                     </table>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:comment>TEI body matter </xsl:comment>
                     <xsl:call-template name="startHook"/>
                     <xsl:variable name="ident">
                        <xsl:apply-templates mode="ident" select="."/>
                     </xsl:variable>
                     <xsl:apply-templates select="tei:text/tei:body"/>
                  </xsl:otherwise>
               </xsl:choose>
               <xsl:comment>TEI back matter </xsl:comment>
               <xsl:apply-templates select="tei:text/tei:back"/>
               <xsl:call-template name="printNotes"/>
               <xsl:call-template name="htmlFileBottom"/>
               <xsl:call-template name="bodyEndHook"/>
            </div>
         </body>
      </html>
   </xsl:template>
   
   
   <!-- naredi strani z div -->
   <xsl:template name="writeDiv">
      <xsl:variable name="BaseFile">
         <xsl:value-of select="$masterFile"/>
         <xsl:call-template name="addCorpusID"/>
      </xsl:variable>
      <!-- vključimo HTML5 deklaracijo, skupaj s kodo za delovanje starejših verzij Internet Explorerja -->
      <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
      <html>
         <xsl:call-template name="addLangAtt"/>
         <xsl:variable name="pagetitle">
            <xsl:choose>
               <xsl:when test="tei:head">
                  <xsl:apply-templates select="tei:head" mode="plain"/>
               </xsl:when>
               <xsl:when test="self::tei:TEI">
                  <xsl:value-of select="tei:generateTitle(.)"/>
               </xsl:when>
               <xsl:when test="self::tei:text">
                  <xsl:value-of select="tei:generateTitle(ancestor::tei:TEI)"/>
                  <xsl:value-of select="concat('[', position(), ']')"/>
               </xsl:when>
               <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:sequence select="tei:htmlHead($pagetitle, 2)"/>
         <body id="TOP">
            <xsl:call-template name="bodyMicroData"/>
            <xsl:call-template name="bodyJavascriptHook"/>
            <xsl:call-template name="bodyHook"/>
            <!-- začetek vsebine -->
            <div class="column row">
               <!-- vstavim svoj header -->
               <xsl:call-template name="html-header">
                  <xsl:with-param name="thisChapter-id">
                     <xsl:value-of select="@xml:id"/>
                  </xsl:with-param>
               </xsl:call-template>
               <!-- GLAVNA VSEBINA -->
               <section>
                  <div class="row">
                     <div class="medium-2 columns show-for-medium">
                        <xsl:call-template name="previousLink"/>
                     </div>
                     <div class="medium-8 small-12 columns">
                        <xsl:call-template name="stdheader">
                           <xsl:with-param name="title">
                              <xsl:call-template name="header"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </div>
                     <div class="medium-2 columns show-for-medium text-right">
                        <xsl:call-template name="nextLink"/>
                     </div>
                  </div>
                  <div class="row hide-for-medium">
                     <div class="small-6 columns text-center">
                        <xsl:call-template name="previousLink"/>
                     </div>
                     <div class="small-6 columns text-center">
                        <xsl:call-template name="nextLink"/>
                     </div>
                  </div>
                  <!--<xsl:if test="$topNavigationPanel = 'true'">
                         <xsl:element name="{if ($outputTarget='html5') then 'nav' else 'div'}">
                            <xsl:call-template name="xrefpanel">
                               <xsl:with-param name="homepage" select="concat($BaseFile, $standardSuffix)"/>
                               <xsl:with-param name="mode" select="local-name(.)"/>
                           </xsl:call-template>
                        </xsl:element>
                      </xsl:if>-->
                  <xsl:if test="$subTocDepth >= 0">
                     <xsl:call-template name="subtoc"/>
                  </xsl:if>
                  <xsl:call-template name="startHook"/>
                  <xsl:call-template name="makeDivBody">
                     <xsl:with-param name="depth" select="count(ancestor::tei:div) + 1"/>
                  </xsl:call-template>
                  <xsl:if test=".//tei:note">
                     <div class="row">
                        <div class="small-6 columns text-center">
                           <xsl:call-template name="previousLink"/>
                        </div>
                        <div class="small-6 columns text-center">
                           <xsl:call-template name="nextLink"/>
                        </div>
                     </div>
                  </xsl:if>
                  <xsl:call-template name="printNotes"/>
                  <div class="row">
                     <div class="small-6 columns text-center">
                        <xsl:call-template name="previousLink"/>
                     </div>
                     <div class="small-6 columns text-center">
                        <xsl:call-template name="nextLink"/>
                     </div>
                  </div>
                  <!--<xsl:if test="$bottomNavigationPanel = 'true'">
                         <xsl:element name="{if ($outputTarget='html5') then 'nav' else 'div'}">
                            <xsl:call-template name="xrefpanel">
                               <xsl:with-param name="homepage" select="concat($BaseFile, $standardSuffix)"/>
                               <xsl:with-param name="mode" select="local-name(.)"/>
                            </xsl:call-template>
                         </xsl:element>
                    </xsl:if>-->
                  <xsl:call-template name="stdfooter"/>
               </section>
            </div><!-- konec vsebine row column -->
            <xsl:call-template name="bodyEndHook"/>
         </body>
      </html>
   </xsl:template>
   
   <xsl:template name="stdheader">
      <xsl:param name="title">(no title)</xsl:param>
      <xsl:choose>
         <xsl:when test="$pageLayout = 'Simple'">
            <xsl:if test="not($institution = '')">
               <h2 class="institution">
                  <xsl:value-of select="$institution"/>
               </h2>
            </xsl:if>
            <xsl:if test="not($department = '')">
               <h2 class="department">
                  <xsl:value-of select="$department"/>
               </h2>
            </xsl:if>
            
            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">maintitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:copy-of select="$title"/>
               </xsl:with-param>
               <!-- spremenim vrednost param level iz 1 v 2, zaradi česar je prvi hn v body vedno h2 
                  (nato sledijo h3 itn. - glej zgoraj param divoffset) -->
               <xsl:with-param name="level">2</xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">subtitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:sequence select="tei:generateSubTitle(.)"/>
               </xsl:with-param>
               <xsl:with-param name="level">2</xsl:with-param>
            </xsl:call-template>
            
            <xsl:if test="$showTitleAuthor = 'true'">
               <xsl:if test="$verbose = 'true'">
                  <xsl:message>displaying author and date</xsl:message>
               </xsl:if>
               <xsl:call-template name="makeHTMLHeading">
                  <xsl:with-param name="class">subtitle</xsl:with-param>
                  <xsl:with-param name="text">
                     <xsl:call-template name="generateAuthorList"/>
                     <xsl:sequence select="tei:generateDate(.)"/>
                     <xsl:sequence select="tei:generateEdition(.)"/>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">maintitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:value-of select="$title"/>
               </xsl:with-param>
               <xsl:with-param name="level">1</xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="makeHTMLHeading">
               <xsl:with-param name="class">subtitle</xsl:with-param>
               <xsl:with-param name="text">
                  <xsl:sequence select="tei:generateTitle(.)"/>
               </xsl:with-param>
               <xsl:with-param name="level">2</xsl:with-param>
            </xsl:call-template>
            
            <xsl:if test="$showTitleAuthor = 'true'">
               <xsl:if test="$verbose = 'true'">
                  <xsl:message>displaying author and date</xsl:message>
               </xsl:if>
               <xsl:call-template name="generateAuthorList"/>
               <xsl:sequence select="tei:generateDate(.)"/>
               <xsl:sequence select="tei:generateEdition(.)"/>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="tei:*" mode="generateNextLink">
      <a class="button">
         <xsl:attribute name="href">
            <xsl:apply-templates mode="generateLink" select="."/>
         </xsl:attribute>
         <xsl:attribute name="title">
            <xsl:sequence select="tei:i18n('nextWord')"/>
            <xsl:text>: </xsl:text>
            <xsl:call-template name="headerLink">
               <xsl:with-param name="minimal" select="$minimalCrossRef"/>
            </xsl:call-template>
         </xsl:attribute>
         <xsl:text>&gt;&gt;</xsl:text>    
      </a>
   </xsl:template>
   
   <xsl:template match="tei:*" mode="generatePreviousLink">
      <a class="button">
         <xsl:attribute name="href">
            <xsl:apply-templates mode="generateLink" select="."/>
         </xsl:attribute>
         <xsl:attribute name="title">
            <xsl:sequence select="tei:i18n('previousWord')"/>
            <xsl:text>: </xsl:text>
            <xsl:call-template name="headerLink">
               <xsl:with-param name="minimal" select="$minimalCrossRef"/>
            </xsl:call-template>
         </xsl:attribute>
         <xsl:text>&lt;&lt;</xsl:text>    
      </a>
   </xsl:template>
   
   <!-- NASLOVNA STRAN -->
   <xsl:template match="tei:titlePage">
      <!-- avtor -->
      <p  class="naslovnicaAvtor">
         <xsl:for-each select="tei:docAuthor">
            <xsl:choose>
               <xsl:when test="tei:forename or tei:surname">
                  <xsl:for-each select="tei:forename">
                     <xsl:value-of select="."/>
                     <xsl:if test="position() ne last()">
                        <xsl:text> </xsl:text>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="tei:surname">
                     <xsl:text> </xsl:text>
                  </xsl:if>
                  <xsl:for-each select="tei:surname">
                     <xsl:value-of select="."/>
                     <xsl:if test="position() ne last()">
                        <xsl:text> </xsl:text>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="."/>
               </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="position() ne last()">
               <br/>
            </xsl:if>
         </xsl:for-each>
      </p>
      <!-- naslov -->
      <xsl:for-each select="tei:docTitle/tei:titlePart[1]">
         <h1 class="text-center"><xsl:value-of select="."/></h1>
         <xsl:for-each select="following-sibling::tei:titlePart">
            <h1 class="subheader podnaslov"><xsl:value-of select="."/></h1>
         </xsl:for-each>
      </xsl:for-each>
      <br/>
      <xsl:if test="tei:figure">
         <div class="text-center">
            <p>
               <img src="{tei:figure/tei:graphic/@url}" alt="naslovna slika"/>
            </p>
         </div>
      </xsl:if>
      <xsl:if test="tei:graphic">
         <div class="text-center">
            <p>
               <img src="{tei:graphic/@url}" alt="naslovna slika"/>
            </p>
         </div>
      </xsl:if>
      <br/>
      <p class="text-center">
         <!-- založnik -->
         <xsl:for-each select="tei:docImprint/tei:publisher">
            <xsl:value-of select="."/>
            <br/>
         </xsl:for-each>
         <!-- kraj izdaje -->
         <xsl:for-each select="tei:docImprint/tei:pubPlace">
            <xsl:value-of select="."/>
            <br/>
         </xsl:for-each>
         <!-- leto izdaje -->
         <xsl:for-each select="tei:docImprint/tei:docDate">
            <xsl:value-of select="."/>
            <br/>
         </xsl:for-each>
      </p>
   </xsl:template>
   
   
</xsl:stylesheet>
