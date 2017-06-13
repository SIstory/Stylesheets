<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="tei" 
    version="2.0">
    
    <xsl:template match="tei:divGen">
        <xsl:variable name="datoteka" select="concat($outputDir,ancestor::tei:TEI/@xml:id,'/',@xml:id,'.html')"/>
        <xsl:result-document href="{$datoteka}" doctype-system="" omit-xml-declaration="yes">
            <!-- vključimo HTML5 deklaracijo, skupaj z kodo za delovanje starejših verzij Internet Explorerja -->
            <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
            <html>
                <xsl:call-template name="addLangAtt"/>
                <!-- vključimo statični head -->
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
                <!-- začetek body -->
                <body id="TOP">
                    <xsl:call-template name="bodyMicroData"/>
                    <xsl:call-template name="bodyJavascriptHook"/>
                    <xsl:call-template name="bodyHook"/>
                    <!-- začetek vsebine -->
                    <div class="column row">
                        <xsl:if test="self::tei:divGen[@type='cip']">
                            <!-- Microdata - schema.org - dodam itemscope -->
                            <xsl:attribute name="itemscope"/>
                            <!-- in itemtype za knjige -->
                            <xsl:attribute name="itemtype">http://schema.org/Book</xsl:attribute>
                        </xsl:if>
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
                                    <xsl:call-template name="previous-divGen-Link">
                                        <xsl:with-param name="thisDivGenType" select="@type"/>
                                    </xsl:call-template>
                                </div>
                                <div class="medium-8 small-12 columns">
                                    <xsl:call-template name="stdheader">
                                        <xsl:with-param name="title">
                                            <xsl:call-template name="header"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </div>
                                <div class="medium-2 columns show-for-medium text-right">
                                    <xsl:call-template name="next-divGen-Link">
                                        <xsl:with-param name="thisDivGenType" select="@type"/>
                                    </xsl:call-template>
                                </div>
                            </div>
                            <div class="row hide-for-medium">
                                <div class="small-6 columns text-center">
                                    <xsl:call-template name="previous-divGen-Link">
                                        <xsl:with-param name="thisDivGenType" select="@type"/>
                                    </xsl:call-template>
                                </div>
                                <div class="small-6 columns text-center">
                                    <xsl:call-template name="next-divGen-Link">
                                        <xsl:with-param name="thisDivGenType" select="@type"/>
                                    </xsl:call-template>
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
                            <!-- VSTAVI VSEBINO divGen strani -->
                            <!-- zaradi lažjega nadzora nad procesiranjem divGen, jih procesiram preko ločenega call-template -->
                            <xsl:call-template name="divGen-main-content"/>
                            
                            <!--<xsl:call-template name="makeDivBody">
                                                <xsl:with-param name="depth" select="count(ancestor::tei:div) + 1"/>
                                            </xsl:call-template>-->
                            <xsl:call-template name="printNotes"/>
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
                    </div>
                    <xsl:call-template name="bodyEndHook"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="previous-divGen-Link">
        <xsl:param name="thisDivGenType"/>
        <xsl:variable name="sistoryPath">
            <xsl:if test="$chapterAsSIstoryPublications='true'">
                <xsl:call-template name="sistoryPath">
                    <xsl:with-param name="chapterID" select="preceding-sibling::tei:divGen[@type = $thisDivGenType][1]/@xml:id"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="preceding-sibling::tei:divGen[@type = $thisDivGenType]">
            <a class="button" href="{concat($sistoryPath,preceding-sibling::tei:divGen[@type = $thisDivGenType][1]/@xml:id,'.html')}" title="{preceding-sibling::tei:divGen[@type = $thisDivGenType][1]/tei:head}">&lt;&lt;</a>
        </xsl:if>
    </xsl:template>
    <xsl:template name="next-divGen-Link">
        <xsl:param name="thisDivGenType"/>
        <xsl:variable name="sistoryPath">
            <xsl:if test="$chapterAsSIstoryPublications='true'">
                <xsl:call-template name="sistoryPath">
                    <xsl:with-param name="chapterID" select="following-sibling::tei:divGen[@type = $thisDivGenType][1]/@xml:id"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="following-sibling::tei:divGen[@type = $thisDivGenType]">
            <a class="button" href="{concat($sistoryPath,following-sibling::tei:divGen[@type = $thisDivGenType][1]/@xml:id,'.html')}" title="{following-sibling::tei:divGen[@type = $thisDivGenType][1]/tei:head}">&gt;&gt;</a>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="divGen-main-content">
        <!-- kolofon CIP -->
        <xsl:if test="self::tei:divGen[@type='cip']">
            <xsl:apply-templates select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc" mode="kolofon"/>
        </xsl:if>
        <!-- TEI kolofon -->
        <xsl:if test="self::tei:divGen[@type='teiHeader']">
            <xsl:apply-templates select="ancestor::tei:TEI/tei:teiHeader"/>
        </xsl:if>
        <!-- kazalo vsebine toc -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='toc'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='toc']">
            <xsl:call-template name="mainTOC"/>
        </xsl:if>
        <!-- kazalo slik -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='images'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='images']">
            <xsl:call-template name="images"/>
        </xsl:if>
        <!-- kazalo grafikonov -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='charts'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='charts']">
            <xsl:call-template name="charts"/>
        </xsl:if>
        <!-- kazalo tabel -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='tables'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='tables']">
            <xsl:call-template name="tables"/>
        </xsl:if>
        <!-- kazalo vsebine toc, ki izpiše samo glavne naslove poglavij, skupaj z imeni avtorjev poglavij -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='titleAuthor'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='titleAuthor']">
            <xsl:call-template name="TOC-title-author"/>
        </xsl:if>
        <!-- kazalo vsebine toc, ki izpiše samo naslove poglavij, kjer ima div atributa type in xml:id -->
        <xsl:if test="self::tei:divGen[@type='toc'][@xml:id='titleType'] | self::tei:divGen[@type='toc'][tokenize(@xml:id,'-')[last()]='titleType']">
            <xsl:call-template name="TOC-title-type"/>
        </xsl:if>
        <!-- seznam (indeks) oseb -->
        <xsl:if test="self::tei:divGen[@type='index'][@xml:id='persons'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='persons']">
            <xsl:call-template name="persons"/>
        </xsl:if>
        <!-- seznam (indeks) krajev -->
        <xsl:if test="self::tei:divGen[@type='index'][@xml:id='places'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='places']">
            <xsl:call-template name="places"/>
        </xsl:if>
        <!-- seznam (indeks) organizacij -->
        <xsl:if test="self::tei:divGen[@type='index'][@xml:id='organizations'] | self::tei:divGen[@type='index'][tokenize(@xml:id,'-')[last()]='organizations']">
            <xsl:call-template name="organizations"/>
        </xsl:if>
        <!-- iskalnik -->
        <xsl:if test="self::tei:divGen[@type='search']">
            <xsl:call-template name="search"/>
        </xsl:if>
    </xsl:template>
    
    <!-- KOLOFON - CIP -->
    
    <xsl:template match="tei:TEI/tei:teiHeader/tei:fileDesc | tei:teiCorpus/tei:teiHeader/tei:fileDesc" mode="kolofon">
        <xsl:apply-templates select="tei:titleStmt" mode="kolofon"/>
        <xsl:apply-templates select="tei:seriesStmt" mode="kolofon"/>
        <xsl:apply-templates select="tei:editionStmt" mode="kolofon"/>
        <xsl:if test="parent::tei:teiHeader[parent::tei:TEI]">
            <xsl:call-template name="countWords"/>
        </xsl:if>
        <xsl:apply-templates select="tei:publicationStmt" mode="kolofon"/>
    </xsl:template>
    
    <xsl:template match="tei:titleStmt" mode="kolofon">
        <!-- avtor -->
        <p>
            <xsl:for-each select="tei:author">
                <span itemprop="author">
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
                </span>
                <xsl:if test="position() != last()">
                    <br/>
                </xsl:if>
            </xsl:for-each>
        </p>
        <!-- Naslov mora vedno biti, zato ne preverjam, če obstaja. -->
        <p itemprop="name">
            <xsl:for-each select="tei:title[1]">
                <b><xsl:value-of select="."/></b>
                <xsl:if test="following-sibling::tei:title">
                    <xsl:text> : </xsl:text>
                </xsl:if>
                <xsl:for-each select="following-sibling::tei:title">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:for-each>
        </p>
        <br/>
        <br/>
        <xsl:apply-templates select="tei:respStmt" mode="kolofon"/>
        <br/>
        <xsl:if test="tei:funder">
            <p itemprop="funder">
                <xsl:value-of select="tei:funder"/>
            </p>
        </xsl:if>
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:seriesStmt" mode="kolofon">
        <p itemprop="isPartOf">
            <xsl:value-of select="tei:title"/>
            <xsl:if test="tei:biblScope[@unit='volume']">
                <xsl:value-of select="concat('; ',tei:biblScope[@unit='volume'])"/>
            </xsl:if>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:editionStmt" mode="kolofon">
        <p itemprop="bookEdition">
            <xsl:apply-templates select="tei:edition" mode="kolofon"/>
        </p>
    </xsl:template>
    <xsl:template match="tei:edition" mode="kolofon">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:publicationStmt" mode="kolofon">
        <xsl:apply-templates select="tei:publisher" mode="kolofon"/>
        <xsl:apply-templates select="tei:date" mode="kolofon"/>
        <xsl:apply-templates select="tei:pubPlace" mode="kolofon"/>
        <xsl:apply-templates select="tei:availability" mode="kolofon"/>
    </xsl:template>
    
    <xsl:template match="tei:respStmt" mode="kolofon">
        <xsl:apply-templates select="tei:resp" mode="kolofon"/>
    </xsl:template>
    <xsl:template match="tei:resp" mode="kolofon">
        <p>
            <em>
                <xsl:value-of select="concat(.,':')"/>
            </em>
            <br />
            <xsl:for-each select="following-sibling::tei:name">
                <span itemprop="contributor">
                    <xsl:apply-templates/>
                </span>
                <br />
            </xsl:for-each>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:publisher" mode="kolofon">
        <p itemprop="publisher">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:date" mode="kolofon">
        <p itemprop="datePublished">
            <xsl:if test="./@when">
                <xsl:attribute name="content">
                    <xsl:value-of select="./@when"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
        <!-- Samo računalniško berljiv microdata zapis za leto izdaje, za katerega velja začetek avtorske pravice -->
        <xsl:choose>
            <xsl:when test="./@when">
                <div itemprop="copyrightYear">
                    <xsl:attribute name="content">
                        <xsl:choose>
                            <xsl:when test="contains(./@when,'-')">
                                <xsl:value-of select="tokenize(./@when,'-')[1]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="./@when"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div itemprop="copyrightYear">
                    <xsl:attribute name="content">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:pubPlace" mode="kolofon">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:availability" mode="kolofon">
        <xsl:apply-templates select="tei:licence" mode="kolofon"/>
        <xsl:if test="tei:p[@rend='ciptitle']">
            <div class="CIP-obroba">
                <xsl:apply-templates select="tei:p[@rend='ciptitle']"/>
                <xsl:apply-templates select="tei:p[@rend='cip']"/>
                <xsl:for-each select="ancestor::tei:publicationStmt/tei:idno[@type='ISBN']">
                    <p>
                        <!-- ista publikacija ima lahko več ISBN številk, vsako za svoj format -->
                        <!-- različne ISBN številke zapisem kot nove elemente idno, ki so childreni glavnega elementa idno -->
                        <xsl:for-each select="tei:idno">
                            <span itemprop="isbn"><xsl:value-of select="."/></span>
                            <xsl:choose>
                                <xsl:when test="position() eq last()"><!-- ne dam praznega prostora --></xsl:when>
                                <xsl:otherwise>
                                    <br />
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </p>
                </xsl:for-each>
                <xsl:apply-templates select="tei:p[@rend='cip-editor']"/>
                <xsl:for-each select="ancestor::tei:publicationStmt/tei:idno[@type='cobiss']">
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </xsl:for-each>
            </div>
        </xsl:if>
        <!-- vstavljena HTML koda za CIP -->
        <xsl:if test="tei:p[@rend='CIP']">
            <div class="CIP-obroba">
                <p>
                    <xsl:value-of select="tei:p[@rend='CIP']" disable-output-escaping="yes"/>
                </p>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:licence" mode="kolofon">
        <!-- dodaj še ostale možne licence -->
        <xsl:if test="contains(.,'/by-nc-nd/4.0/')">
            <p>
                <a rel="license" href="{.}">
                    <img alt="Creative Commons licenca" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" />
                </a>
                <br />
                <xsl:sequence select="tei:i18n('by-nc-nd/4.0 text 1')"/><xsl:text> </xsl:text>
                <span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text" rel="dct:type">
                    <xsl:sequence select="tei:i18n('by-nc-nd/4.0 text 2')"/>
                </span>
                <xsl:if test="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
                    <xsl:text> </xsl:text>
                    <xsl:sequence select="tei:i18n('by-nc-nd/4.0 text 3')"/>
                    <xsl:text> </xsl:text>
                    <a xmlns:cc="http://creativecommons.org/ns#" property="cc:attributionName" rel="cc:attributionURL" href="{ancestor::tei:publicationStmt/tei:pubPlace/tei:ref}">
                        <!-- Poiščem avtorje.
                         Imena in priimki ločeni s presledkom, avtorji z vejico -->
                        <xsl:for-each select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
                            <xsl:for-each select="tei:forename">
                                <xsl:value-of select="concat(.,' ')"/>
                            </xsl:for-each>
                            <xsl:for-each select="tei:surname">
                                <xsl:value-of select="."/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:if test="position() != last()">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </a>
                </xsl:if>
                <xsl:text> </xsl:text>
                <xsl:sequence select="tei:i18n('by-nc-nd/4.0 text 4')"/>
                <xsl:text> </xsl:text>
                <a rel="license" href="{.}">
                    <xsl:sequence select="tei:i18n('by-nc-nd/4.0 text 5')"/>
                </a>
            </p>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:p[@rend='ciptitle']">
        <p><xsl:apply-templates/></p>
        <br/>
    </xsl:template>
    <xsl:template match="tei:p[@rend='cip']">
        <p><xsl:apply-templates/></p>
        <br/>
    </xsl:template>
    <xsl:template match="tei:p[@rend='cip-editor']">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <!-- TEI KOLOFON -->
    <xsl:template match="tei:TEI/tei:teiHeader | tei:teiCorpus/tei:teiHeader">
        <dl>
            <dt>
                <xsl:choose>
                    <xsl:when test="$element-gloss-teiHeader = 'true'">
                        <xsl:call-template name="node-gloss"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="name()"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="@*">
                    <xsl:call-template name="teiHeader-dl-atributes"/>
                </xsl:if>
            </dt>
            <dd>
                <xsl:call-template name="teiHeader-dl"/>
            </dd>
        </dl>
    </xsl:template>
    
    <xsl:template name="teiHeader-dl">
        <dl>
            <xsl:for-each select="*">
                <dt>
                    <xsl:choose>
                        <xsl:when test="$element-gloss-teiHeader = 'true'">
                            <xsl:call-template name="node-gloss"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="name()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="@*">
                        <xsl:call-template name="teiHeader-dl-atributes"/>
                    </xsl:if>
                </dt>
                <xsl:if test="text() and child::*">
                    <dd>
                        <xsl:value-of select="text()"/>
                        <xsl:call-template name="teiHeader-dl"/>
                    </dd>
                </xsl:if>
                <xsl:if test="not(text()) and child::*">
                    <dd>
                        <xsl:call-template name="teiHeader-dl"/>
                    </dd>
                </xsl:if>
                <xsl:if test="text() and not(child::*)">
                    <dd>
                        <xsl:value-of select="text()"/>
                    </dd>
                </xsl:if>
                <xsl:if test="not(text()) and not(child::*)">
                    <dd></dd>
                </xsl:if>
            </xsl:for-each>
        </dl>    
    </xsl:template>
    
    <xsl:template name="teiHeader-dl-atributes">
        <xsl:text> [</xsl:text>
        <xsl:for-each select="@*">
            <xsl:variable name="attribute-label">
                <xsl:variable name="attribute-name" select="name()"/>
                <xsl:variable name="attribute-gloss">
                    <xsl:for-each select="document('../teiLocalise-sl.xml')/tei:TEI/tei:text/tei:body/tei:classSpec//tei:attDef[@ident = $attribute-name]">
                        <xsl:choose>
                            <xsl:when test="tei:gloss[@xml:lang = $element-gloss-teiHeader-lang]">
                                <xsl:value-of select="tei:gloss[@xml:lang = $element-gloss-teiHeader-lang]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$attribute-name"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>    
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="string-length($attribute-gloss) gt 0">
                        <xsl:value-of select="$attribute-gloss"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$attribute-name"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$element-gloss-teiHeader = 'true'">
                    <xsl:value-of select="concat($attribute-label,' = ',.)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat(name(),' = ',.)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="position() != last()">
                <xsl:text> | </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template name="node-gloss">
        <xsl:variable name="node-ident" select="name()"/>
        <xsl:variable name="node-names">
            <xsl:for-each select="document('../teiLocalise-sl.xml')/tei:TEI/tei:text/tei:body/tei:elementSpec[@ident = $node-ident]">
                <xsl:for-each select="tei:gloss">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$node-names/tei:gloss[@xml:lang = $element-gloss-teiHeader-lang]">
                <xsl:value-of select="$node-names/tei:gloss[@xml:lang = $element-gloss-teiHeader-lang]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$node-ident"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- KAZALO SLIK -->
    <xsl:template name="images">
        <!-- izpiše vse slike -->
        <ul class="circel">
            <xsl:for-each select="//tei:figure[not(@type='chart')]">
                <xsl:variable name="figure-id" select="@xml:id"/>
                <xsl:variable name="image-chapter-id" select="ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/@xml:id"/>
                <xsl:variable name="sistoryPath">
                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                        <xsl:call-template name="sistoryPath">
                            <xsl:with-param name="chapterID" select="$image-chapter-id"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <li>
                    <a href="{concat($sistoryPath,$image-chapter-id,'.html#',$figure-id)}">
                        <xsl:value-of select="tei:head"/>
                    </a>
                </li>
            </xsl:for-each>
        </ul><!-- konec procesiranja slik -->
    </xsl:template>
    
    <!-- KAZALO GRAFIKONOV -->
    <xsl:template name="charts">
        <!-- izpiše vse slike -->
        <ul class="circel">
            <xsl:for-each select="//tei:figure[@type='chart']">
                <xsl:variable name="figure-id" select="@xml:id"/>
                <xsl:variable name="image-chapter-id" select="ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/@xml:id"/>
                <xsl:variable name="sistoryPath">
                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                        <xsl:call-template name="sistoryPath">
                            <xsl:with-param name="chapterID" select="$image-chapter-id"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <li>
                    <a href="{concat($sistoryPath,$image-chapter-id,'.html#',$figure-id)}">
                        <xsl:value-of select="tei:head"/>
                    </a>
                </li>
            </xsl:for-each>
        </ul><!-- konec procesiranja slik -->
    </xsl:template>
    
    <!-- KAZALO TABEL -->
    <xsl:template name="tables">
        <!-- izpiše vse tabele, ki imajo naslov (s tem filtriramo tiste tabele, ki so v okviru grafikonov) -->
        <ul class="circel">
            <xsl:for-each select="//tei:table[tei:head]">
                <xsl:variable name="table-id" select="@xml:id"/>
                <xsl:variable name="table-chapter-id" select="ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/@xml:id"/>
                <xsl:variable name="sistoryPath">
                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                        <xsl:call-template name="sistoryPath">
                            <xsl:with-param name="chapterID" select="$table-chapter-id"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <li>
                    <a href="{concat($sistoryPath,$table-chapter-id,'.html#',$table-id)}">
                        <xsl:value-of select="tei:head"/>
                    </a>
                </li>
            </xsl:for-each>
        </ul><!-- konec procesiranja slik -->
    </xsl:template>
    
    <!-- SEZNAM (INDEKS) OSEB -->
    <xsl:template name="persons">
        <ul class="no-bullet">
            <xsl:variable name="rules"><![CDATA[< 0 < 1 < 2 < 3 < 4 < 5 < 6 < 7 < 8 < 9 < Ä=A,ä=á=ă=a < B,b < C,c < Č=Ć,č=ć < D,d < Đ,đ < E,é=e < F,f < G,g < H,h < I,í=i < J,j < K,k < Ł=L,l < M,m < N,ň=n < Ö=O,ö=ő=ó=o < P,p < Q,q < R,r=ř < ß=SS,ß=ss < S,s < Š,š < T,t < Ü=U,ü=u < V,v < W,w < X,x < Y,y < Z,z < Ž,ž]]></xsl:variable>
            <xsl:for-each select="//tei:person[@xml:id]">
                <xsl:sort select="translate(normalize-space(tei:persName[1]/tei:surname[1]), '.-_()[]/:;&quot;?''', '')" collation="http://saxon.sf.net/collation?rules={encode-for-uri($rules)}" data-type="text" order="ascending"/>
                <xsl:sort select="translate(normalize-space(tei:persName[1]/tei:surname[2]), '.-_()[]/:;&quot;?''', '')" collation="http://saxon.sf.net/collation?rules={encode-for-uri($rules)}" data-type="text" order="ascending"/>
                <xsl:sort select="translate(normalize-space(tei:persName[1]/tei:forename[1]), '.-_()[]/:;&quot;?''', '')" collation="http://saxon.sf.net/collation?rules={encode-for-uri($rules)}" data-type="text" order="ascending"/>
                <xsl:sort select="translate(normalize-space(tei:persName[1]/tei:forename[2]), '.-_()[]/:;&quot;?''', '')" collation="http://saxon.sf.net/collation?rules={encode-for-uri($rules)}" data-type="text" order="ascending"/>
                <xsl:sort select="normalize-space(tei:birth[1]/tei:date[1]/@when)" collation="http://saxon.sf.net/collation?rules={encode-for-uri($rules)}" data-type="text" order="ascending"/>
                <xsl:variable name="person-id" select="concat('#',./@xml:id)"/>
                <!-- Ker ima vsak atribut xml:id, se vzame njegova vrednost kot anchor -->
                <li id="{@xml:id}">
                    <span itemscope="" itemtype="http://schema.org/Person">
                        <span itemprop="name">
                            <!-- ista oseba ima lahko več imen (če se je npr. preimenovala) -->
                            <!-- kot ključno vzamemo prvo ime (NAKNADNO PREMISLI TO PRAVILO!!!!!!!!!!!) -->
                            <xsl:for-each select="tei:persName[1]">
                                <xsl:for-each select="tei:surname[not(@type='alt')][not(@type='maiden')]">
                                    <xsl:value-of select="."/>
                                    <xsl:choose>
                                        <xsl:when test="position() eq last()">
                                            <xsl:choose>
                                                <!-- v oklepaju alternativni priimek -->
                                                <xsl:when test="ancestor::tei:person/tei:persName[2]/tei:surname">
                                                    <xsl:text> (</xsl:text>
                                                    <xsl:for-each select="ancestor::tei:person/tei:persName[2]/tei:surname">
                                                        <xsl:value-of select="."/>
                                                        <xsl:choose>
                                                            <xsl:when test=" position() eq last()">
                                                                <xsl:text>)</xsl:text>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:text>, </xsl:text>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <!-- konec naštevanja priimkov -->
                                                <xsl:otherwise>
                                                    <xsl:text></xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text> </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <!-- če so priimki in imena je med njimi vejica -->
                                <xsl:if test="tei:surname[not(@type='maiden')] and tei:forename">
                                    <xsl:text>, </xsl:text>
                                </xsl:if>
                                <xsl:for-each select="tei:forename[not(@type='alt')]">
                                    <xsl:value-of select="."/>
                                    <xsl:choose>
                                        <xsl:when test="position() eq last()">
                                            <xsl:choose>
                                                <!-- v oklepaju alternativno ime -->
                                                <xsl:when test="ancestor::tei:person/tei:persName[2]/tei:forename">
                                                    <xsl:text> (</xsl:text>
                                                    <xsl:for-each select="ancestor::tei:person/tei:persName[2]/tei:forename">
                                                        <xsl:value-of select="."/>
                                                        <xsl:choose>
                                                            <xsl:when test=" position() eq last()">
                                                                <xsl:text>)</xsl:text>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:text>, </xsl:text>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <!-- konec naštevanja imen -->
                                                <xsl:otherwise>
                                                    <xsl:text></xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text> </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <!-- za vladarje -->
                                <xsl:if test="tei:genName">
                                    <xsl:value-of select="concat(' ',tei:genName)"/>
                                </xsl:if>
                                <xsl:if test="tei:surname[@type='maiden']">
                                    <xsl:text> roj. </xsl:text>
                                </xsl:if>
                                <xsl:for-each select="tei:surname[@type='maiden']">
                                    <xsl:value-of select="."/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:for-each><!-- konec procesiranja osebnih imen -->
                        </span>
                        <!-- prazen prostor (pet praznih znakov) pred navajanji, kje je oseba zapisana -->
                        <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text>
                        <xsl:for-each select="//tei:persName[@ref = $person-id]">
                            <xsl:variable name="ancestorChapter-id" select="ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/@xml:id"/>
                            <xsl:variable name="sistoryPath">
                                <xsl:if test="$chapterAsSIstoryPublications='true'">
                                    <xsl:call-template name="sistoryPath">
                                        <xsl:with-param name="chapterID" select="$ancestorChapter-id"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="numLevel">
                                <xsl:number count="tei:text//tei:persName" level="any"/>
                            </xsl:variable>
                            <xsl:variable name="numPerson">
                                <xsl:number value="$numLevel"/>
                            </xsl:variable>
                            <xsl:variable name="persNameID">
                                <xsl:value-of select="concat('person-',$numPerson)"/>
                            </xsl:variable>
                            <a href="{concat($sistoryPath,$ancestorChapter-id,'.html#',$persNameID)}">
                                <xsl:value-of select="substring-after($persNameID,'person-')"/>
                            </a>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <!-- zakonci in otroci -->
                        <ul class="circle">
                            <!-- zakonci -->
                            <xsl:for-each select="//tei:relation[@name='spouse'][tokenize(@mutual,' ') = $person-id]">
                                <xsl:text disable-output-escaping="yes"><![CDATA[<li>Zakonec: ]]></xsl:text>
                                <xsl:variable name="spouseID">
                                    <xsl:for-each select="./tokenize(@mutual,' ')">
                                        <!-- ker je samo eden zakonski partner, lahko drugega najdemo z variablo -->
                                        <xsl:if test=". != $person-id">
                                            <xsl:value-of select="substring-after(.,'#')"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:for-each select="//tei:person[@xml:id = $spouseID]">
                                    <span itemprop="spouse">
                                        <a class="person" href="{concat('#',./@xml:id)}">
                                            <xsl:value-of select="tei:persName[1]/tei:forename[1]"/>
                                        </a>
                                    </span>
                                    <xsl:text>; </xsl:text>
                                </xsl:for-each>
                                <xsl:text disable-output-escaping="yes"><![CDATA[</li>]]></xsl:text>
                            </xsl:for-each>
                            <!-- otroci -->
                            <xsl:for-each select="//tei:relation[@name='parent'][tokenize(@active,' ') = $person-id]">
                                <xsl:text disable-output-escaping="yes"><![CDATA[<li>Otroci: ]]></xsl:text>
                                <!-- ker je lahko več otrok, jih ne moremo takoj dati v variablo 
                                     in vrednost variable nato primerjati s s for-each //tei:person (ker da atomsko vrednost),
                                     zato sem jih procesiarl kot skupine. (Obstaja verjetno bolj primeren način - najdi !!!!
                                     Mi ga ni uspelo najti - tudi uporaba distinct-values ne deluje zaradi zgornjega razloga. -->
                                <xsl:for-each-group select="." group-by="tokenize(./@passive,' ')">
                                    <xsl:for-each select="current-group()">
                                        <xsl:variable name="childID" select="substring-after(current-grouping-key(),'#')"/>
                                        <xsl:for-each select="//tei:person[@xml:id = $childID]">
                                            <xsl:sort select="translate(normalize-space(tei:persName[1]/tei:forename[1]), '.-_()[]/:;&quot;?''', '')" collation="http://saxon.sf.net/collation?rules={encode-for-uri($rules)}" data-type="text" order="ascending"/>
                                            <span itemprop="children">
                                                <a class="person" href="{concat('#',./@xml:id)}">
                                                    <xsl:value-of select="tei:persName[1]/tei:forename[1]"/>
                                                </a>
                                            </span>
                                            <xsl:text>; </xsl:text>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:for-each-group>
                                <xsl:text disable-output-escaping="yes"><![CDATA[</li>]]></xsl:text>
                            </xsl:for-each>
                            <!-- starši -->
                            <xsl:for-each select="//tei:relation[@name='parent'][tokenize(@passive,' ') = $person-id]">
                                <xsl:text disable-output-escaping="yes"><![CDATA[<li>Starši: ]]></xsl:text>
                                <xsl:for-each-group select="." group-by="tokenize(./@active,' ')">
                                    <xsl:for-each select="current-group()">
                                        <xsl:variable name="parentID" select="substring-after(current-grouping-key(),'#')"/>
                                        <xsl:for-each select="//tei:person[@xml:id = $parentID]">
                                            <xsl:sort select="translate(normalize-space(tei:persName[1]/tei:forename[1]), '.-_()[]/:;&quot;?''', '')" collation="http://saxon.sf.net/collation?rules={encode-for-uri($rules)}" data-type="text" order="ascending"/>
                                            <span itemprop="parent">
                                                <a class="person" href="{concat('#',./@xml:id)}">
                                                    <xsl:value-of select="tei:persName[1]/tei:forename[1]"/>
                                                </a>
                                            </span>
                                            <xsl:text>; </xsl:text>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:for-each-group>
                                <xsl:text disable-output-escaping="yes"><![CDATA[</li>]]></xsl:text>
                            </xsl:for-each>
                        </ul>
                    </span><!-- konec schema.org -->
                </li>
            </xsl:for-each><!-- konec procesiranja osebe (tei:person) -->
        </ul>
    </xsl:template>
    
    <!-- SEZNAM (INDEKS) KRAJEV -->
    <xsl:template name="places">
        <ul class="no-bullet">
            <xsl:variable name="rules"><![CDATA[< 0 < 1 < 2 < 3 < 4 < 5 < 6 < 7 < 8 < 9 < Ä=A,ä=á=ă=a < B,b < C,c < Č=Ć,č=ć < D,d < Đ,đ < E,é=e < F,f < G,g < H,h < I,í=i < J,j < K,k < Ł=L,l < M,m < N,ň=n < Ö=O,ö=ő=ó=o < P,p < Q,q < R,r=ř < ß=SS,ß=ss < S,s < Š,š < T,t < Ü=U,ü=u < V,v < W,w < X,x < Y,y < Z,z < Ž,ž]]></xsl:variable>
            <xsl:for-each select="//tei:place">
                <xsl:sort select="translate(normalize-space(tei:placeName[@type='reg'][1]), '.-_()[]/:;&quot;?''', '')" collation="http://saxon.sf.net/collation?rules={encode-for-uri($rules)}" data-type="text" order="ascending"/>
                <!-- ali imajo elementi place (znotraj listPlace) @xml:id ali pa @corresp -->
                <xsl:variable name="place-id" select="concat('#',./@xml:id)"/>
                <xsl:variable name="place-url" select="./@corresp"/>
                <!-- Le redko kateri tei:place imajo @xml:id 
                     (samo tisti, ki nimajo ustrezne povezave na geonames ali dbpedia),
                      zato za vse ostale avtomatično naredimo nov id. -->
                <li>
                    <xsl:attribute name="id">
                        <xsl:choose>
                            <xsl:when test="@xml:id">
                                <xsl:value-of select="./@xml:id"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="numLevel">
                                    <xsl:number count="tei:place" level="any"/>
                                </xsl:variable>
                                <xsl:variable name="numPlace">
                                    <xsl:number value="$numLevel"/>
                                </xsl:variable>
                                <xsl:value-of select="concat('place-',$numPlace)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <span itemscope="" itemtype="http://schema.org/Place">
                        <span itemprop="name">
                            <!-- ime kraja -->
                            <xsl:choose>
                                <xsl:when test="tei:placeName[@type='reg'][@xml:lang='slv']">
                                    <xsl:value-of select="tei:placeName[@type='reg'][@xml:lang='slv']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="tei:placeName[@type='reg']"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </span>
                        <!-- prazen prostor (pet praznih znakov) pred navajanji, kje je kraj zapisana -->
                        <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text>
                        <xsl:for-each select="//tei:text//tei:placeName[@ref = $place-id]">
                            <xsl:variable name="ancestorChapter-id" select="ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/@xml:id"/>
                            <xsl:variable name="sistoryPath">
                                <xsl:if test="$chapterAsSIstoryPublications='true'">
                                    <xsl:call-template name="sistoryPath">
                                        <xsl:with-param name="chapterID" select="$ancestorChapter-id"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="numLevel">
                                <xsl:number count="tei:text//tei:placeName" level="any"/>
                            </xsl:variable>
                            <xsl:variable name="numPlaceName">
                                <xsl:number value="$numLevel"/>
                            </xsl:variable>
                            <xsl:variable name="placeNameID">
                                <xsl:value-of select="concat('kraj-',$numPlaceName)"/>
                            </xsl:variable>
                            <a href="{concat($sistoryPath,$ancestorChapter-id,'.html#',$placeNameID)}">
                                <xsl:value-of select="substring-after($placeNameID,'kraj-')"/>
                            </a>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="//tei:text//tei:placeName[@corresp = $place-url]">
                            <xsl:variable name="ancestorChapter-id" select="ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/@xml:id"/>
                            <xsl:variable name="sistoryPath">
                                <xsl:if test="$chapterAsSIstoryPublications='true'">
                                    <xsl:call-template name="sistoryPath">
                                        <xsl:with-param name="chapterID" select="$ancestorChapter-id"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="numLevel">
                                <xsl:number count="tei:text//tei:placeName" level="any"/>
                            </xsl:variable>
                            <xsl:variable name="numPlaceName">
                                <xsl:number value="$numLevel"/>
                            </xsl:variable>
                            <xsl:variable name="placeNameID">
                                <xsl:value-of select="concat('kraj-',$numPlaceName)"/>
                            </xsl:variable>
                            <a href="{concat($sistoryPath,$ancestorChapter-id,'.html#',$placeNameID)}">
                                <xsl:value-of select="substring-after($placeNameID,'kraj-')"/>
                            </a>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                        <!-- povezave na zemljevide -->
                        <xsl:if test=".[@corresp]">
                            <!-- pet praznih prostorov nato pa začetek oglatega oklepaja [ -->
                            <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[]]></xsl:text>
                            <a href="{./@corresp}" target="_blank">
                                <xsl:choose>
                                    <xsl:when test="contains(./@corresp,'geonames')">
                                        <xsl:text>geonames</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="contains(./@corresp,'dbpedia.org')">
                                        <xsl:text>dbpedia.org</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:message terminate="yes">V tei:person/@corresp neznana povezava (ni geonems ali dbpedia).</xsl:message>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </a>
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                        <xsl:if test="tei:location/tei:geo">
                            <!-- pet praznih prostorov nato pa začetek oglatega oklepaja [ -->
                            <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[]]></xsl:text>
                            <a target="_blank">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="concat('https://maps.google.com/maps?q=',substring-before(tei:location/tei:geo,' '),',',substring-after(tei:location/tei:geo,' '))"/>
                                </xsl:attribute>
                                <xsl:text>google</xsl:text>
                            </a>
                            <xsl:text>]</xsl:text>
                        </xsl:if>
                    </span><!-- konec schema.org -->
                </li>
            </xsl:for-each><!-- konec procesiranja kraja (tei:place) -->
        </ul>
    </xsl:template>
    
    <!-- SEZNAM (INDEKS) ORGANIZACIJ -->
    <xsl:template name="organizations">
        <ul class="no-bullet">
            <xsl:variable name="rules"><![CDATA[< 0 < 1 < 2 < 3 < 4 < 5 < 6 < 7 < 8 < 9 < Ä=A,ä=á=ă=a < B,b < C,c < Č=Ć,č=ć < D,d < Đ,đ < E,é=e < F,f < G,g < H,h < I,í=i < J,j < K,k < Ł=L,l < M,m < N,ň=n < Ö=O,ö=ő=ó=o < P,p < Q,q < R,r=ř < ß=SS,ß=ss < S,s < Š,š < T,t < Ü=U,ü=u < V,v < W,w < X,x < Y,y < Z,z < Ž,ž]]></xsl:variable>
            <xsl:for-each select="//tei:org[@xml:id]">
                <xsl:sort select="translate(normalize-space(tei:orgName[1]), '.-_()[]/:;&quot;?''', '')" collation="http://saxon.sf.net/collation?rules={encode-for-uri($rules)}" data-type="text" order="ascending"/>
                <xsl:variable name="organization-id" select="concat('#',./@xml:id)"/>
                <!-- Ker ima vsak atribut xml:id, se vzame njegova vrednost kot anchor -->
                <li id="{./@xml:id}">
                    <span itemscope="" itemtype="http://schema.org/Organization">
                        <span itemprop="name">
                            <!-- ista oseba ima lahko zapisanih več imen, vsako v svoji vrstici -->
                            <!-- kot ključno vzamemo prvo ime (NAKNADNO PREMISLI TO PRAVILO!!!!!!!!!!!) -->
                            <xsl:value-of select="tei:orgName[1]"/>
                        </span>
                        <!-- prazen prostor (pet praznih znakov) pred navajanji, kje je oseba zapisana -->
                        <xsl:text disable-output-escaping="yes"><![CDATA[&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;]]></xsl:text>
                        <xsl:for-each select="//tei:orgName[@ref = $organization-id]">
                            <xsl:variable name="ancestorChapter-id" select="ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/@xml:id"/>
                            <xsl:variable name="sistoryPath">
                                <xsl:if test="$chapterAsSIstoryPublications='true'">
                                    <xsl:call-template name="sistoryPath">
                                        <xsl:with-param name="chapterID" select="$ancestorChapter-id"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:variable>
                            <xsl:variable name="numLevel">
                                <xsl:number count="tei:text//tei:orgName" level="any"/>
                            </xsl:variable>
                            <xsl:variable name="numOrganization">
                                <xsl:number value="$numLevel"/>
                            </xsl:variable>
                            <xsl:variable name="orgNameID">
                                <xsl:value-of select="concat('org-',$numOrganization)"/>
                            </xsl:variable>
                            <a href="{concat($sistoryPath,$ancestorChapter-id,'.html#',$orgNameID)}">
                                <xsl:value-of select="substring-after($orgNameID,'org-')"/>
                            </a>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </span><!-- konec schema.org -->
                </li>
            </xsl:for-each><!-- konec procesiranja osebe (tei:person) -->
        </ul>
    </xsl:template>
    
    <xsl:template name="search">
        <xsl:variable name="tei-id" select="ancestor::tei:TEI/@xml:id"/>
        <xsl:variable name="sistoryAbsolutePath">
            <xsl:if test="$chapterAsSIstoryPublications='true'">http://www.sistory.si</xsl:if>
        </xsl:variable>
        <div class="tipue_search_content">
            <xsl:text> </xsl:text>
            <xsl:variable name="datoteka-js" select="concat($outputDir,ancestor::tei:TEI/@xml:id,'/','tipuesearch_content.js')"/>
            <xsl:result-document href="{$datoteka-js}" method="text" encoding="UTF-8">
                <!-- ZAČETEK JavaScript dokumenta -->
                <xsl:text>var tipuesearch = {"pages": [
                                    </xsl:text>
                <!-- Shrani celotno besedilo v indeks za:
                     - vse child elemente od div, ki imajo @xml:id;
                     - vse child elemente od izbranih list elementov:
                         - list element ne sme imeti @xml:id,
                         - child element mora imeti @xml:id
                -->
                <xsl:for-each select="//node()[ancestor::tei:TEI/@xml:id = $tei-id][@xml:id][ancestor::tei:text][parent::tei:div][not(self::tei:div)] |
                    //tei:listPerson[ancestor::tei:TEI/@xml:id = $tei-id][not(@xml:id)][ancestor::tei:text][parent::tei:div]/node()[@xml:id] |
                     //tei:listPlace[ancestor::tei:TEI/@xml:id = $tei-id][not(@xml:id)][ancestor::tei:text][parent::tei:div]/node()[@xml:id] |
                       //tei:listOrg[ancestor::tei:TEI/@xml:id = $tei-id][not(@xml:id)][ancestor::tei:text][parent::tei:div]/node()[@xml:id] |
                     //tei:listEvent[ancestor::tei:TEI/@xml:id = $tei-id][not(@xml:id)][ancestor::tei:text][parent::tei:div]/node()[@xml:id] |
                      //tei:listBibl[ancestor::tei:TEI/@xml:id = $tei-id][not(@xml:id)][ancestor::tei:text][parent::tei:div]/node()[@xml:id] |
                          //tei:list[ancestor::tei:TEI/@xml:id = $tei-id][not(@xml:id)][ancestor::tei:text][parent::tei:div]/node()[@xml:id]">
                    <!--<xsl:variable name="ancestorChapter-id" select="ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/@xml:id"/>-->
                    <xsl:variable name="generatedLink">
                        <xsl:apply-templates mode="generateLink" select="."/>
                    </xsl:variable>
                    <xsl:variable name="besedilo">
                        <xsl:apply-templates mode="besedilo"/>
                    </xsl:variable>
                    <xsl:text>{ "title": "</xsl:text>
                    <xsl:value-of select="normalize-space(translate(translate(parent::tei:div/tei:head[1],'&#xA;',' '),'&quot;',''))"/>
                    <!--<xsl:value-of select="normalize-space(translate(translate(ancestor::tei:div[@xml:id][parent::tei:front | parent::tei:body | parent::tei:back]/tei:head[1],'&#xA;',' '),'&quot;',''))"/>-->
                    <xsl:text>", "text": "</xsl:text>
                    <xsl:value-of select="normalize-space(translate($besedilo,'&#xA;&quot;','&#x20;'))"/>
                    <xsl:text>", "tags": "</xsl:text>
                    <xsl:text>", "loc": "</xsl:text>
                    <xsl:value-of select="concat($sistoryAbsolutePath,$generatedLink)"/>
                    <!--<xsl:value-of select="concat($ancestorChapter-id,'.html#',@xml:id)"/>-->
                    <xsl:text>" }</xsl:text>
                    <xsl:if test="position() != last()">
                        <xsl:text>,</xsl:text>
                    </xsl:if>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:for-each>
                
                <!-- KONEC JavaScript dokumenta -->
                <xsl:text>
                     ]};
                </xsl:text>
            </xsl:result-document>
        </div>
        
        <!-- JavaScript, s katerim se požene iskanje -->
        <xsl:text disable-output-escaping="yes"><![CDATA[<script>
            $(document).ready(function() {
            $('.tipue_search_input').tipuesearch({
            'show': 10,
            'highlightEveryTerm': true,
            'descriptiveWords': 250});
            });
        </script>]]></xsl:text>
    </xsl:template>
    
    <xsl:template match="node()" mode="besedilo" xml:space="preserve">
        <xsl:copy>
            <xsl:apply-templates select="node()" mode="besedilo"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="TOC-title-author">
        <xsl:if test="//tei:front">
            <ul class="toc toc_front">
                <xsl:for-each select="//tei:front/tei:div | //tei:front/tei:divGen[not(@type = 'search')][not(@type = 'cip')][not(@type = 'teiHeader')][not(@type = 'toc')]">
                    <xsl:call-template name="TOC-title-author-li"/>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <ul class="toc toc_body">
            <xsl:for-each select="//tei:body/tei:div">
                <xsl:call-template name="TOC-title-author-li"/>
            </xsl:for-each>
        </ul>
        <xsl:if test="//tei:back">
            <ul class="toc toc_back">
                <xsl:for-each select="//tei:back/tei:div | //tei:back/tei:divGen">
                    <xsl:call-template name="TOC-title-author-li"/>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="TOC-title-author-li">
        <li class="toc">
            <a>
                <xsl:attribute name="href">
                    <xsl:apply-templates mode="generateLink" select="."/>
                </xsl:attribute>
                <xsl:for-each select="tei:head">
                    <xsl:apply-templates select="." mode="chapters-head"/>
                    <xsl:if test="position() != last()">
                        <xsl:text>: </xsl:text>
                    </xsl:if>
                </xsl:for-each>                    
            </a>
            <xsl:if test="tei:docAuthor">
                <xsl:text> (</xsl:text>
                <xsl:for-each select="tei:docAuthor">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </li>
    </xsl:template>
    
    <xsl:template name="TOC-title-type">
        <xsl:if test="//tei:front/tei:div[@type][@xml:id] | //tei:front/tei:divGen">
            <ul class="toc toc_front">
                <xsl:for-each select="//tei:front/tei:div[@type][@xml:id] | //tei:front/tei:divGen[not(@type = 'search')][not(@type = 'cip')][not(@type = 'teiHeader')][not(@type = 'toc')]">
                    <xsl:call-template name="TOC-title-type-li"/>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <ul class="toc toc_body">
            <xsl:for-each select="//tei:body/tei:div[@type][@xml:id]">
                <xsl:call-template name="TOC-title-type-li"/>
            </xsl:for-each>
        </ul>
        <xsl:if test="//tei:back/tei:div[@type][@xml:id] | //tei:back/tei:divGen">
            <ul class="toc toc_back">
                <xsl:for-each select="//tei:back/tei:div[@type][@xml:id] | //tei:back/tei:divGen">
                    <xsl:call-template name="TOC-title-type-li"/>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="TOC-title-type-li">
        <li class="toc">
            <a>
                <xsl:attribute name="href">
                    <xsl:apply-templates mode="generateLink" select="."/>
                </xsl:attribute>
                <xsl:for-each select="tei:head">
                    <xsl:variable name="chaptersHead">
                        <xsl:apply-templates select="." mode="chapters-head"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="parent::tei:div[@type='part']">
                            <xsl:value-of select="upper-case($chaptersHead)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$chaptersHead"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="position() != last()">
                        <xsl:text>: </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:if test="tei:div[@type][@xml:id]">
                    <ul>
                        <xsl:for-each select="tei:div[@type][@xml:id]">
                            <xsl:call-template name="TOC-title-type-li"/>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </a>
        </li>
    </xsl:template>
    
    <xsl:template name="countWords">
        <xsl:variable name="string" select="normalize-space(ancestor::tei:TEI/tei:text)"/> 
        <p>
            <xsl:value-of select="concat(tei:i18n('WordCount'),': ')"/>
            <xsl:value-of select="concat(tei:i18n('Words'),' ')"/>
            <xsl:value-of select="count(tokenize(normalize-space($string),'\W+')[. != ''])"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="concat(tei:i18n('Characters (with spaces)'),' ')"/>
            <xsl:value-of select="string-length(normalize-space($string))"/>
            <xsl:text>.</xsl:text>
        </p>
    </xsl:template>
    
</xsl:stylesheet>