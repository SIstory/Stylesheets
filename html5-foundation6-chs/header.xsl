<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="tei" 
    version="2.0">
    
    <xsl:template name="attribute-href-to-sistory">
        <xsl:attribute name="href">
            <xsl:choose>
                <xsl:when test="//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace/tei:ref">
                    <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace/tei:ref"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>http://www.sistory.si</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template name="html-header">
        <xsl:param name="thisChapter-id"/>
        <header>
            <div class="hide-for-large">
                <xsl:if test="$title-bar-sticky = 'true'">
                    <xsl:attribute name="data-sticky-container"/>
                </xsl:if>
                <div id="header-bar">
                    <xsl:if test="$title-bar-sticky = 'true'">
                        <xsl:attribute name="data-sticky"/>
                        <xsl:attribute name="data-sticky-on">small</xsl:attribute>
                        <xsl:attribute name="data-options">marginTop:0;</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="data-top-anchor">1</xsl:attribute>
                    </xsl:if>
                    <div class="title-bar" data-responsive-toggle="publication-menu" data-hide-for="large">
                        <button class="menu-icon" type="button" data-toggle=""></button>
                        <div class="title-bar-title">
                            <xsl:sequence select="tei:i18n('Menu')"/>
                        </div>
                        <div class="title-bar-right">
                            <a class="title-bar-title">
                                <xsl:call-template name="attribute-href-to-sistory"/>
                                <i class="fi-home" style="color:white;"></i>
                            </a>
                        </div>
                        <div id="publication-menu" class="hide-for-large">
                            <ul class="vertical menu" data-drilldown="" data-options="backButton: &lt;li class=&quot;js-drilldown-back&quot;&gt;&lt;a tabindex=&quot;0&quot;&gt;{tei:i18n('Nazaj')}&lt;/a&gt;&lt;/li&gt;;">
                                <xsl:call-template name="title-bar-list-of-contents">
                                    <xsl:with-param name="title-bar-type">vertical</xsl:with-param>
                                    <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                                </xsl:call-template>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="show-for-large">
                <xsl:if test="$title-bar-sticky = 'true'">
                    <xsl:attribute name="data-sticky-container"/>
                </xsl:if>
                <nav class="title-bar">
                    <xsl:if test="$title-bar-sticky = 'true'">
                        <xsl:attribute name="data-sticky"/>
                        <xsl:attribute name="data-options">marginTop:0;</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="data-top-anchor">1</xsl:attribute>
                    </xsl:if>
                    <div class="title-bar-left">
                        <a class="title-bar-title">
                            <xsl:call-template name="attribute-href-to-sistory"/>
                            <i class="fi-home" style="color:white;"></i><xsl:text> </xsl:text><span>SIstory</span>
                        </a>
                    </div>
                    <div class="title-bar-right">
                        <ul class="dropdown menu" data-dropdown-menu="">
                            <xsl:call-template name="title-bar-list-of-contents">
                                <xsl:with-param name="title-bar-type">dropdown</xsl:with-param>
                                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                            </xsl:call-template>
                        </ul>
                    </div>
                </nav>
            </div>
            
            <!-- iskalnik -->
            <form action="search.html">
                <div class="row collapse">
                    <div class="small-10 large-11 columns">
                        <input type="text" name="q" class="tipue_search_input" placeholder="{tei:i18n('Search placeholder')}" />
                    </div>
                    <div class="small-2 large-1 columns">
                        <input type="button" class="tipue_search_button" onclick="this.form.submit();"/>
                    </div>
                </div>
            </form>
        </header>
    </xsl:template>
    
    <xsl:template name="title-bar-list-of-contents">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <!-- Poiščemo vse možne dele publikacije -->
        <!-- Naslovnica - index.html je vedno -->
        <li>
            <xsl:if test="$thisChapter-id = 'index'">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <a href="index.html">
                <xsl:sequence select="tei:i18n('Naslovnica')"/>
            </a>
        </li>
        <!-- kolofon CIP -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip']">
            <li>
                <xsl:if test=".[@type='cip']">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <a href="{concat(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip']/@xml:id,'.html')}">
                    <xsl:value-of select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip']/tei:head[1]"/>
                </a>
            </li>
        </xsl:if>
        <!-- TEI kolofon -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='teiHeader']">
            <li>
                <xsl:if test=".[@type='teiHeader']">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <a href="{concat(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='teiHeader']/@xml:id,'.html')}">
                    <xsl:value-of select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='teiHeader']/tei:head[1]"/>
                </a>
            </li>
        </xsl:if>
        <!-- kazalo toc -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc']">
            <li>
                <xsl:if test=".[@type='toc']">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <!-- povezava na prvi toc -->
                <a href="{concat(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc'][1]/@xml:id,'.html')}">
                    <xsl:call-template name="nav-toc-head"/>
                </a>
                <xsl:if test="//tei:front/tei:divGen[@type='toc'][2]">
                    <ul>
                        <xsl:call-template name="attribute-title-bar-type">
                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                        </xsl:call-template>
                        <xsl:for-each select="//tei:front/tei:divGen[@type='toc']">
                            <xsl:variable name="chapters-id" select="@xml:id"/>
                            <xsl:choose>
                                <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                    <li class="active">
                                        <a href="{concat($thisChapter-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{concat($chapters-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </li>
        </xsl:if>
        <!-- Uvodna poglavja v tei:front -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div">
            <li>
                <xsl:if test=".[parent::tei:front][self::tei:div]">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <!-- povezava na prvi front/div -->
                <a href="{concat(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[1]/@xml:id,'.html')}">
                    <xsl:call-template name="nav-front-head"/>
                </a>
                <xsl:if test="//tei:front/tei:div[2]">
                    <ul>
                        <xsl:call-template name="attribute-title-bar-type">
                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                        </xsl:call-template>
                        <xsl:for-each select="//tei:front/tei:div">
                            <xsl:variable name="chapters-id" select="@xml:id"/>
                            <xsl:choose>
                                <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                    <li class="active">
                                        <a href="{concat($thisChapter-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                        </xsl:call-template>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{concat($chapters-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                        </xsl:call-template>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </li>
        </xsl:if>
        <!-- Osrednji del besedila v tei:body - Poglavja -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div">
            <li>
                <xsl:if test=".[parent::tei:body][self::tei:div]">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <!-- povezava na prvi body/div -->
                <a href="{concat(ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[1]/@xml:id,'.html')}">
                    <xsl:call-template name="nav-body-head"/>
                </a>
                <xsl:if test="//tei:body/tei:div[2]">
                    <ul>
                        <xsl:call-template name="attribute-title-bar-type">
                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                        </xsl:call-template>
                        <xsl:for-each select="//tei:body/tei:div">
                            <xsl:variable name="chapters-id" select="@xml:id"/>
                            <xsl:choose>
                                <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                    <li class="active">
                                        <a href="{concat($thisChapter-id,'.html')}">
                                            <xsl:apply-templates select="tei:head[1]" mode="chapters-head"/>
                                        </a>
                                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                        </xsl:call-template>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{concat($chapters-id,'.html')}">
                                            <xsl:apply-templates select="tei:head[1]" mode="chapters-head"/>
                                        </a>
                                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                        </xsl:call-template>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </li>
        </xsl:if>
        <!-- viri in literatura v tei:back -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr']">
            <li>
                <xsl:if test=".[@type='bibliogr']">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <!-- povezava na prvi div z bibliogr -->
                <a href="{concat(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr'][1]/@xml:id,'.html')}">
                    <xsl:sequence select="tei:i18n('Bibliografija')"/>
                </a>
                <xsl:if test="//tei:back/tei:div[@type='bibliogr'][2]">
                    <ul>
                        <xsl:call-template name="attribute-title-bar-type">
                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                        </xsl:call-template>
                        <xsl:for-each select="//tei:back/tei:div[@type='bibliogr']">
                            <xsl:variable name="chapters-id" select="@xml:id"/>
                            <xsl:choose>
                                <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                    <li class="active">
                                        <a href="{concat($thisChapter-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                        </xsl:call-template>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{concat($chapters-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                        </xsl:call-template>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </li>
        </xsl:if>
        <!-- Priloge v tei:back -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix']">
            <li>
                <xsl:if test=".[@type='appendix']">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <!-- povezava na prvi div z bibliogr -->
                <a href="{concat(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix'][1]/@xml:id,'.html')}">
                    <xsl:call-template name="nav-appendix-head"/>
                </a>
                <xsl:if test="//tei:back/tei:div[@type='appendix'][2]">
                    <ul>
                        <xsl:call-template name="attribute-title-bar-type">
                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                        </xsl:call-template>
                        <xsl:for-each select="//tei:back/tei:div[@type='appendix']">
                            <xsl:variable name="chapters-id" select="@xml:id"/>
                            <xsl:choose>
                                <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                    <li class="active">
                                        <a href="{concat($thisChapter-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                        </xsl:call-template>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{concat($chapters-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                        </xsl:call-template>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </li>
        </xsl:if>
        <!-- povzetki -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary']">
            <li>
                <xsl:if test=".[@type='summary']">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <!-- povezava na prvi div z bibliogr -->
                <a href="{concat(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary'][1]/@xml:id,'.html')}">
                    <xsl:call-template name="nav-summary-head"/>
                </a>
                <xsl:if test="//tei:back/tei:div[@type='summary'][2]">
                    <ul>
                        <xsl:call-template name="attribute-title-bar-type">
                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                        </xsl:call-template>
                        <xsl:for-each select="//tei:back/tei:div[@type='summary']">
                            <xsl:variable name="chapters-id" select="@xml:id"/>
                            <xsl:choose>
                                <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                    <li class="active">
                                        <a href="{concat($thisChapter-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                        </xsl:call-template>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{concat($chapters-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                        </xsl:call-template>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </li>
        </xsl:if>
        <!-- Indeksi (oseb, krajev in organizacij) v divGen -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='index']">
            <li>
                <xsl:if test=".[@type='index']">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <!-- povezava na prvi toc -->
                <a href="{concat(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='index'][1]/@xml:id,'.html')}">
                    <xsl:call-template name="nav-index-head"/>
                </a>
                <xsl:if test="//tei:back/tei:divGen[@type='index'][2]">
                    <ul>
                        <xsl:call-template name="attribute-title-bar-type">
                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                        </xsl:call-template>
                        <xsl:for-each select="//tei:back/tei:divGen[@type='index']">
                            <xsl:variable name="chapters-id" select="@xml:id"/>
                            <xsl:choose>
                                <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                    <li class="active">
                                        <a href="{concat($thisChapter-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                    </li>
                                </xsl:when>
                                <xsl:otherwise>
                                    <li>
                                        <a href="{concat($chapters-id,'.html')}">
                                            <xsl:value-of select="tei:head[1]"/>
                                        </a>
                                    </li>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </ul>
                </xsl:if>
            </li>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:head" mode="chapters-head">
        <xsl:apply-templates mode="chapters-head"/>
    </xsl:template>
    <xsl:template match="tei:note" mode="chapters-head">
        <!-- ne procesimar -->
    </xsl:template>
    
    <xsl:template name="attribute-title-bar-type">
        <xsl:param name="title-bar-type"/>
        <xsl:attribute name="class">
            <xsl:if test="$title-bar-type = 'vertical'">vertical menu</xsl:if>
            <xsl:if test="$title-bar-type = 'dropdown'">menu</xsl:if>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template name="title-bar-list-of-contents-subchapters">
        <xsl:param name="title-bar-type"/>
        <xsl:if test="tei:div[@type='subchapter']">
            <ul>
                <xsl:attribute name="class">
                    <xsl:if test="$title-bar-type = 'vertical'">vertical menu</xsl:if>
                    <xsl:if test="$title-bar-type = 'dropdown'">menu</xsl:if>
                </xsl:attribute>
                <xsl:for-each select="tei:div[@type='subchapter']">
                    <li>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:variable name="this-subchapterID" select="@xml:id"/>
                                <xsl:value-of select="concat(ancestor::tei:div[1]/@xml:id,'.html#',$this-subchapterID)"/>
                            </xsl:attribute>
                            <xsl:apply-templates select="tei:head[1]" mode="chapters-head"/>
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>
    
    <!-- izpis imena, glede na število kazal -->
    <xsl:template name="nav-toc-head">
        <xsl:choose>
            <xsl:when test="count(//tei:divGen[@type='toc']) = 1">
                <xsl:sequence select="tei:i18n('Kazalo')"/>
            </xsl:when>
            <xsl:when test="count(//tei:divGen[@type='toc']) = 2">
                <xsl:sequence select="tei:i18n('Kazali')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="tei:i18n('Kazala')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- izpis imena, glede na število indeksov (krajevnih, osebnih, organizacij) -->
    <xsl:template name="nav-index-head">
        <xsl:choose>
            <xsl:when test="count(//tei:divGen[@type='index']) = 1">
                <xsl:sequence select="tei:i18n('Indeks')"/>
            </xsl:when>
            <xsl:when test="count(//tei:divGen[@type='index']) = 2">
                <xsl:sequence select="tei:i18n('Indeksa')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="tei:i18n('Indeksi')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- izpis imena, glede na število front/div -->
    <xsl:template name="nav-front-head">
        <xsl:choose>
            <xsl:when test="count(//tei:div[parent::tei:front]) = 1">
                <xsl:sequence select="tei:i18n('Uvod')"/>
            </xsl:when>
            <xsl:when test="count(//tei:div[parent::tei:front]) = 2">
                <xsl:sequence select="tei:i18n('Uvoda')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="tei:i18n('Uvodi')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- izpis imena, glede na število body/div -->
    <xsl:template name="nav-body-head">
        <xsl:choose>
            <xsl:when test="count(//tei:div[parent::tei:body]) = 1">
                <xsl:sequence select="tei:i18n('Poglavje')"/>
            </xsl:when>
            <xsl:when test="count(//tei:div[parent::tei:body]) = 2">
                <xsl:sequence select="tei:i18n('Poglavji')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="tei:i18n('Poglavja')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- izpis imena, glede na število back/div -->
    <xsl:template name="nav-appendix-head">
        <xsl:choose>
            <xsl:when test="count(//tei:div[@type='appendix']) = 1">
                <xsl:sequence select="tei:i18n('Priloga')"/>
            </xsl:when>
            <xsl:when test="count(//tei:div[@type='appendix']) = 2">
                <xsl:sequence select="tei:i18n('Prilogi')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="tei:i18n('Priloge')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- izpis imena, glede na število back/div -->
    <xsl:template name="nav-summary-head">
        <xsl:choose>
            <xsl:when test="count(//tei:div[@type='summary']) = 1">
                <xsl:sequence select="tei:i18n('Povzetek')"/>
            </xsl:when>
            <xsl:when test="count(//tei:div[@type='summary']) = 2">
                <xsl:sequence select="tei:i18n('Povzetka')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="tei:i18n('Povzetki')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
