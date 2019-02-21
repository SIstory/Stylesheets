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
   <xsl:import href="../../tei-xsl-7.47.0/xml/tei/stylesheet/html5/html5.xsl"/>
   <!-- change path to your TEI Stylesheets https://github.com/TEIC/Stylesheets/blob/master/html5/microdata.xsl -->
   <xsl:import href="../../tei-xsl-7.47.0/xml/tei/stylesheet/html5/microdata.xsl"/>
   
   <xsl:import href="new-html_figures.xsl"/>
   <xsl:import href="new-html_core.xsl"/>
   
   <xsl:import href="header.xsl"/>
   <xsl:import href="divGen.xsl"/>
   <xsl:import href="off-canvas.xsl"/>
   
   <xsl:import href="my-html_param.xsl"/>
   <xsl:import href="my-html_core.xsl"/>
   <xsl:import href="bibliography.xsl"/>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>TEI stylesheet for making HTML5 output (Zurb Foundation 5 http://foundation.zurb.com/sites/docs/v/5.5.3/).</p>
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
   
   <xsl:output method="xhtml" omit-xml-declaration="yes" indent="no"/>
   <xsl:param name="doctypeSystem"></xsl:param>
   
   <!-- verbose - izpišejo se pojansila; koristno v času kodiranja (true), drugače odstrani oz. false -->
   <xsl:param name="verbose">false</xsl:param>
   
   <xsl:param name="outputDir">rezultat</xsl:param>
   <xsl:param name="splitLevel">0</xsl:param>
   <xsl:param name="STDOUT">false</xsl:param>
   
   <!-- head v drugem div je h3 itn. Glej še spodaj template stdheader -->
   <xsl:param name="divOffset">2</xsl:param>
   
   <xsl:template name="stdfooter"/>
   
   <!-- prevod: opombe, slike ipd. Pobere iz ../i18n.xml -->
   <xsl:param name="documentationLanguage">sl</xsl:param>
   
   <xsl:param name="institution"></xsl:param>
   <xsl:param name="footnoteBackLink">true</xsl:param>
   <xsl:param name="generateParagraphIDs">true</xsl:param>
   <xsl:param name="numberBackHeadings"></xsl:param>
   <xsl:param name="numberFigures">true</xsl:param>
   <xsl:param name="numberFrontTables">true</xsl:param>
   <xsl:param name="numberHeadings">true</xsl:param>
   <xsl:param name="numberParagraphs">true</xsl:param>
   <xsl:param name="numberTables">true</xsl:param>
   
   <xsl:template name="headHook">
      <meta name="viewport" content="width=device-width" />
      <meta name="description"
         content="{$description}"/>
      <meta name="keywords" content="{$keywords}"/>
   </xsl:template>
   <xsl:param name="cssFile">../../../publikacije/themes/foundation/5/css/foundation.min.css</xsl:param>
   <xsl:param name="cssPrintFile"></xsl:param>
   <xsl:param name="cssSecondaryFile">../../../publikacije/themes/css/foundation/5/sistory.css</xsl:param>
   <xsl:template name="cssHook">
      <link href="../../../publikacije/themes/plugin/foundation/zurb-responsive-tables/2.1.4./responsive-tables.css"  rel="stylesheet" type="text/css" />
      <link href="../../../publikacije/themes/plugin/foundation/zurb-responsive-tables-large-screens/2.1.4/responsive-tables.css" rel="stylesheet" type="text/css" />
      <link href="../../../publikacije/themes/css/plugin/TipueSearch/3.1/moj_class_tipuesearch.css"  rel="stylesheet" type="text/css" />
   </xsl:template>
   <xsl:template name="javascriptHook">
      <script src="../../../publikacije/themes/foundation/5/js/jquery.js"></script>
      <script src="../../../publikacije/themes/foundation/5/js/vendor/custom.modernizr.js"></script>
      <script src="../../../publikacije/themes/plugin/foundation/zurb-responsive-tables/2.1.4./responsive-tables.js"></script>
      <script src="../../../publikacije/themes/plugin/foundation/zurb-responsive-tables-large-screens/2.1.4/responsive-tables.js"></script>
      <!-- za iskalnik tipue -->
      <xsl:if test="//tei:divGen[@type='search']">
         <!-- v spodnjem js je shranjena vsebina za iskanje -->
         <script src="tipuesearch_content.js"></script>
         <script src="../../../publikacije/themes/plugin/TipueSearch/3.1/tipuesearch/tipuesearch_set.js"></script>
         <script src="../../../publikacije/themes/js/plugin/TipueSearch/3.1/moj_class_tipuesearch.js"></script>
      </xsl:if>
      <!-- za back-to-top je drugače potrebno dati jquery, vendar sedaj ne rabim dodajati jquery kodo, ker je že vsebovana zgoraj -->
      <!--<script src="http://code.jquery.com/jquery-1.11.3.min.js"></script>-->
   </xsl:template>
   <xsl:template name="bodyEndHook">
      <script src="../../../publikacije/themes/foundation/5/js/foundation.min.js"></script>
      <script src="../../../publikacije/themes/foundation/5/js/foundation/foundation.accordion.js"></script>
      <script src="../../../publikacije/themes/foundation/5/js/foundation/foundation.alert.js"></script>
      <script src="../../../publikacije/themes/foundation/5/js/foundation/foundation.dropdown.js"></script>
      <script src="../../../publikacije/themes/foundation/5/js/foundation/foundation.js"></script>
      <script src="../../../publikacije/themes/foundation/5/js/foundation/foundation.offcanvas.js"></script>
      <script src="../../../publikacije/themes/foundation/5/js/foundation/foundation.tab.js"></script>
      <script src="../../../publikacije/themes/foundation/5/js/foundation/foundation.tooltip.js"></script>
      <script src="../../../publikacije/themes/foundation/5/js/foundation/foundation.topbar.js"></script>
      <script>
         $(document).foundation();
      </script>
      <!-- back-to-top -->
      <script src="../../../publikacije/themes/js/plugin/back-to-top/back-to-top.js"></script>
   </xsl:template>
   
   <!-- naredi index.html datoteko -->
   <xsl:template name="pageLayoutSimple">
      <!-- vključimo HTML5 deklaracijo, skupaj s kodo za delovanje starejših verzij Internet Explorerja -->
      <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
      <html>
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
            <!-- vstavim svoj header -->
            <xsl:call-template name="html-header"/>
            <!-- glavna vsebina strani -->
            <div class="row">
               <div class="large-12 columns">
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
               </div><!-- konec large-12 columns -->
            </div><!-- konec row -->
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
            <!-- vstavim svoj header -->
            <xsl:call-template name="html-header"/>
            <!-- glavna vsebina strani -->
            <div class="row">
               <!-- dodam navigacijo off-canvas -->
               <div class="off-canvas-wrap docs-wrap">
                  <div class="inner-wrap">
                     <!-- izpis navigacije off-canvas in iskanje -->
                     <xsl:call-template name="off-canvas">
                        <xsl:with-param name="thisChapter-id">
                           <xsl:value-of select="@xml:id"/>
                        </xsl:with-param>
                     </xsl:call-template>
                     
                     <!-- GLAVNA VSEBINA -->
                     <section class="main-section">
                        <div class="row">
                           <div class="large-12 columns">
                              <div class="row show-for-medium-up">
                                 <div class="medium-2 columns">
                                    <xsl:call-template name="previousLink"/>
                                 </div>
                                 <div class="medium-8 columns">
                                    <xsl:call-template name="stdheader">
                                       <xsl:with-param name="title">
                                          <xsl:call-template name="header"/>
                                       </xsl:with-param>
                                    </xsl:call-template>
                                 </div>
                                 <div class="medium-2 columns text-right">
                                    <xsl:call-template name="nextLink"/>
                                 </div>
                              </div>
                              <div class="row show-for-small">
                                 <div class="small-12 columns">
                                    <xsl:call-template name="stdheader">
                                       <xsl:with-param name="title">
                                          <xsl:call-template name="header"/>
                                       </xsl:with-param>
                                    </xsl:call-template>
                                 </div>
                              </div>
                              <div class="row show-for-small">
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
                              <xsl:call-template name="bodyEndHook"/>
                           </div>
                        </div>
                     </section>
                     <!-- KONEC OFF-CANVAS -->
                     <a class="exit-off-canvas"></a>
                  </div><!-- konec inner wrap -->
               </div><!-- konec of canvas -->
            </div><!-- konec row -->
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
      <a class="small button radius">
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
      <a class="small button radius">
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
