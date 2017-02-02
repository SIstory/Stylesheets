<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="tei" 
    version="2.0">
    
    <xsl:template name="attribute-href-to-repository">
        <xsl:attribute name="href">
            <xsl:choose>
                <xsl:when test="self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID'][starts-with(.,'sistory.')]">
                    <xsl:value-of select="concat('http://hdl.handle.net/11686/',substring-after(self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID'][starts-with(.,'sistory.')],'sistory.'))"/>
                </xsl:when>
                <xsl:when test="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID'][starts-with(.,'sistory.')]">
                    <xsl:value-of select="concat('http://hdl.handle.net/11686/',substring-after(ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID'][starts-with(.,'sistory.')],'sistory.'))"/>
                </xsl:when>
                <xsl:when test="self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
                    <xsl:variable name="teiParentId" select="self::tei:teiCorpus/@xml:id"/>
                    <xsl:variable name="sistoryId">
                        <xsl:if test="$chapterAsSIstoryPublications='true'">
                            <xsl:call-template name="sistoryID">
                                <xsl:with-param name="chapterID" select="$teiParentId"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:value-of select="concat('http://hdl.handle.net/11686/',$sistoryId)"/>
                </xsl:when>
                <xsl:when test="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
                    <xsl:variable name="teiParentId" select="ancestor-or-self::tei:TEI/@xml:id"/>
                    <xsl:variable name="sistoryId">
                        <xsl:if test="$chapterAsSIstoryPublications='true'">
                            <xsl:call-template name="sistoryID">
                                <xsl:with-param name="chapterID" select="$teiParentId"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:variable>
                    <xsl:value-of select="concat('http://hdl.handle.net/11686/',$sistoryId)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace/tei:ref">
                            <!-- upoštevamo samo prvo povezavo -->
                            <xsl:value-of select="self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace[tei:ref][1]/tei:ref"/>
                        </xsl:when>
                        <xsl:when test="ancestor-or-self::tei:TEI/tei:fileDesc/tei:publicationStmt/tei:pubPlace/tei:ref">
                            <!-- upoštevamo samo prvo povezavo -->
                            <xsl:value-of select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace[tei:ref][1]/tei:ref"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>http://www.sistory.si</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
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
                                <xsl:call-template name="attribute-href-to-repository"/>
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
                            <xsl:call-template name="attribute-href-to-repository"/>
                            <i class="fi-home" style="color:white;"></i>
                            <xsl:text> </xsl:text>
                            <span>
                                <xsl:choose>
                                    <xsl:when test="self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID']">
                                        <xsl:choose>
                                            <xsl:when test="self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID'][starts-with(.,'sistory.')]">SIstory</xsl:when>
                                            <!-- se v nove when lahko dodate še druge potencialne ustanove -->
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID']">
                                        <xsl:choose>
                                            <xsl:when test="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID'][starts-with(.,'sistory.')]">SIstory</xsl:when>
                                            <!-- se v nove when lahko dodate še druge potencialne ustanove -->
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">SIstory</xsl:when>
                                    <xsl:when test="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">SIstory</xsl:when>
                                    <xsl:otherwise>SIstory</xsl:otherwise>
                                </xsl:choose>
                            </span>
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
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='search']">
                <xsl:variable name="sistoryPath-search">
                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                        <xsl:call-template name="sistoryPath">
                            <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='search']/@xml:id"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <form action="{concat($sistoryPath-search,ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='search']/@xml:id,'.html')}">
                    <div class="row collapse">
                        <div class="small-10 large-11 columns">
                            <input type="text" name="q" class="tipue_search_input" placeholder="{tei:i18n('Search placeholder')}" />
                        </div>
                        <div class="small-2 large-1 columns">
                            <input type="button" class="tipue_search_button" onclick="this.form.submit();"/>
                        </div>
                    </div>
                </form>
            </xsl:if>
        </header>
    </xsl:template>
    
    <xsl:template name="title-bar-list-of-contents">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:variable name="sistoryParentPath">
            <xsl:choose>
                <xsl:when test="self::tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
                    <xsl:variable name="teiParentId" select="self::tei:teiCorpus/@xml:id"/>
                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                        <xsl:call-template name="sistoryPath">
                            <xsl:with-param name="chapterID" select="$teiParentId"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
                    <xsl:variable name="teiParentId" select="ancestor-or-self::tei:TEI/@xml:id"/>
                    <xsl:if test="$chapterAsSIstoryPublications='true'">
                        <xsl:call-template name="sistoryPath">
                            <xsl:with-param name="chapterID" select="$teiParentId"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <!-- Poiščemo vse možne dele publikacije -->
        <!-- Naslovnica - index.html je vedno, kadar ni procesirano iz teiCorpus in ima hkrati TEI svoj xml:id -->
        <li>
            <xsl:if test="$thisChapter-id = 'index'">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <a>
                <xsl:attribute name="href">
                    <xsl:choose>
                        <xsl:when test="ancestor::tei:teiCorpus and ancestor-or-self::tei:TEI[@xml:id]">
                            <xsl:value-of select="concat($sistoryParentPath,ancestor-or-self::tei:TEI/@xml:id,'.html')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($sistoryParentPath,'index.html')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="tei:text[@type = 'article'] or ancestor::tei:text[@type = 'article'] or self::tei:teiCorpus/tei:TEI/tei:text[@type = 'article']">
                        <xsl:sequence select="tei:i18n('Naslov')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Naslovnica')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
        </li>
        <!-- kolofon CIP -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip']">
            <xsl:call-template name="header-cip">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- kolofon CIP za teiCorpus za revije -->
        <xsl:if test="self::tei:teiCorpus and $write-teiCorpus-cip='true'">
            <!-- TODO sistoryPath za teiCorpus -->
            <li>
                <xsl:if test="$thisChapter-id='cip'">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <a href="impressum.html">
                    <xsl:sequence select="tei:i18n('impressum')"/>
                </a>
            </li>
        </xsl:if>
        <!-- TEI kolofon -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='teiHeader']">
            <xsl:call-template name="header-teiHeader">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- TEI kolofon za teiCorpus za revije -->
        <xsl:if test="self::tei:teiCorpus and $write-teiCorpus-teiHeader='true'">
            <!-- TODO sistoryPath za teiCorpus -->
            <li>
                <xsl:if test="$thisChapter-id='teiHeader'">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <a href="teiHeader.html">
                    <xsl:sequence select="tei:i18n('teiHeader')"/>
                </a>
            </li>
        </xsl:if>
        <!-- kazalo toc titleAuthor za teiCorpus za revije (predpogoj: tei:text mora imeti @n) -->
        <xsl:if test="self::tei:teiCorpus and $write-teiCorpus-toc_titleAuthor='true'">
            <!-- TODO sistoryPath za teiCorpus -->
            <li>
                <xsl:if test="$thisChapter-id='tocJournal'">
                    <xsl:attribute name="class">active</xsl:attribute>
                </xsl:if>
                <a href="tocJournal.html">
                    <xsl:sequence select="tei:i18n('tocJournal')"/>
                </a>
            </li>
        </xsl:if>
        <!-- kazalo toc -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc']">
            <xsl:call-template name="header-toc">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- Uvodna poglavja v tei:front -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div">
            <xsl:call-template name="header-front">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- Osrednji del besedila v tei:body - Poglavja -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div">
            <xsl:call-template name="header-body">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- viri in literatura v tei:back -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr']">
            <xsl:call-template name="header-bibliogr">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- Priloge v tei:back -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix']">
            <xsl:call-template name="header-appendix">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- povzetki -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary']">
            <xsl:call-template name="header-summary">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
        <!-- Indeksi (oseb, krajev in organizacij) v divGen -->
        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='index']">
            <xsl:call-template name="header-back-index">
                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                <xsl:with-param name="sistoryParentPath" select="$sistoryParentPath"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="header-cip">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <xsl:variable name="sistoryPath-cip">
            <xsl:if test="$chapterAsSIstoryPublications='true'">
                <xsl:call-template name="sistoryPath">
                    <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip']/@xml:id"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <li>
            <xsl:if test=".[@type='cip']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <a href="{concat($sistoryPath-cip,ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip']/@xml:id,'.html')}">
                <xsl:value-of select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='cip']/tei:head[1]"/>
            </a>
        </li>
    </xsl:template>
    
    <xsl:template name="header-teiHeader">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <xsl:variable name="sistoryPath-teiHeader">
            <xsl:if test="$chapterAsSIstoryPublications='true'">
                <xsl:call-template name="sistoryPath">
                    <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='teiHeader']/@xml:id"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>
        <li>
            <xsl:if test=".[@type='teiHeader']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <a href="{concat($sistoryPath-teiHeader,ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='teiHeader']/@xml:id,'.html')}">
                <xsl:value-of select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='teiHeader']/tei:head[1]"/>
            </a>
        </li>
    </xsl:template>
    
    <xsl:template name="header-toc">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='toc']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi toc -->
            <xsl:variable name="sistoryPath-toc1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc'][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-toc1,ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc'][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-toc-head"/>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc'][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc']">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-toc">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-toc,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-toc,$chapters-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <xsl:template name="header-front">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[parent::tei:front][self::tei:div]">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi front/div -->
            <xsl:variable name="sistoryPath-front1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-front1,ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-front-head"/>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div[2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-front">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-front,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-front,$chapters-id,'.html')}">
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
    </xsl:template>
    
    <xsl:template name="header-body">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[ancestor::tei:body][self::tei:div]">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi body/div -->
            <xsl:variable name="sistoryPath-body1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-body1,ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-body-head"/>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div">
                        <!--<xsl:variable name="chapters-id" select="@xml:id"/>-->
                        <li>
                            <xsl:if test="descendant-or-self::tei:div[@xml:id = $thisChapter-id]">
                                <xsl:attribute name="class">active</xsl:attribute>
                            </xsl:if>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:apply-templates mode="generateLink" select="."/>
                                </xsl:attribute>
                                <xsl:apply-templates select="tei:head[1]" mode="chapters-head"/>
                            </a>
                            <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                                <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                            </xsl:call-template>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
    </xsl:template>
    
    <xsl:template name="header-bibliogr">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='bibliogr']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi div z bibliogr -->
            <xsl:variable name="sistoryPath-bibliogr1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr'][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-bibliogr1,ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr'][1]/@xml:id,'.html')}">
                <xsl:sequence select="tei:i18n('Bibliografija')"/>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr'][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr']">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-bibliogr">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-bibliogr,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-bibliogr,$chapters-id,'.html')}">
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
    </xsl:template>
    
    <xsl:template name="header-appendix">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='appendix']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi div z appendix -->
            <xsl:variable name="sistoryPath-appendix1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix'][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-appendix1,ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix'][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-appendix-head"/>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix'][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix']">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-appendix">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-appendix,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-appendix,$chapters-id,'.html')}">
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
    </xsl:template>
    
    <xsl:template name="header-summary">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='summary']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi div z summary -->
            <xsl:variable name="sistoryPath-summary1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary'][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-summary1,ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary'][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-summary-head"/>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary'][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary']">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-summary">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-summary,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                    <xsl:call-template name="title-bar-list-of-contents-subchapters">
                                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                                    </xsl:call-template>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-summary,$chapters-id,'.html')}">
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
    </xsl:template>
    
    <xsl:template name="header-back-index">
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:param name="sistoryParentPath"/>
        <li>
            <xsl:if test=".[@type='index']">
                <xsl:attribute name="class">active</xsl:attribute>
            </xsl:if>
            <!-- povezava na prvi indeks -->
            <xsl:variable name="sistoryPath-index1">
                <xsl:if test="$chapterAsSIstoryPublications='true'">
                    <xsl:call-template name="sistoryPath">
                        <xsl:with-param name="chapterID" select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='index'][1]/@xml:id"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <a href="{concat($sistoryPath-index1,ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='index'][1]/@xml:id,'.html')}">
                <xsl:call-template name="nav-index-head"/>
            </a>
            <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='index'][2]">
                <ul>
                    <xsl:call-template name="attribute-title-bar-type">
                        <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                    </xsl:call-template>
                    <xsl:for-each select="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='index']">
                        <xsl:variable name="chapters-id" select="@xml:id"/>
                        <xsl:variable name="sistoryPath-index">
                            <xsl:if test="$chapterAsSIstoryPublications='true'">
                                <xsl:call-template name="sistoryPath">
                                    <xsl:with-param name="chapterID" select="$chapters-id"/>
                                </xsl:call-template>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test=".[$chapters-id eq $thisChapter-id]">
                                <li class="active">
                                    <a href="{concat($sistoryPath-index,$thisChapter-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                </li>
                            </xsl:when>
                            <xsl:otherwise>
                                <li>
                                    <a href="{concat($sistoryPath-index,$chapters-id,'.html')}">
                                        <xsl:value-of select="tei:head[1]"/>
                                    </a>
                                </li>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </ul>
            </xsl:if>
        </li>
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
        <xsl:param name="thisChapter-id"/>
        <xsl:param name="title-bar-type"/>
        <xsl:if test="tei:div[@xml:id][@type]">
            <ul>
                <xsl:attribute name="class">
                    <xsl:if test="$title-bar-type = 'vertical'">vertical menu</xsl:if>
                    <xsl:if test="$title-bar-type = 'dropdown'">menu</xsl:if>
                </xsl:attribute>
                <xsl:for-each select="tei:div">
                    <li>
                        <xsl:if test="descendant-or-self::tei:div[@xml:id = $thisChapter-id]">
                            <xsl:attribute name="class">active</xsl:attribute>
                        </xsl:if>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:apply-templates mode="generateLink" select="."/>
                            </xsl:attribute>
                            <!--<xsl:attribute name="href">
                                <xsl:variable name="this-subchapterID" select="@xml:id"/>
                                <xsl:value-of select="concat(ancestor::tei:div[1]/@xml:id,'.html#',$this-subchapterID)"/>
                            </xsl:attribute>-->
                            <xsl:apply-templates select="tei:head[1]" mode="chapters-head"/>
                        </a>
                        <xsl:call-template name="title-bar-list-of-contents-subchapters">
                            <xsl:with-param name="thisChapter-id" select="$thisChapter-id"/>
                            <xsl:with-param name="title-bar-type" select="$title-bar-type"/>
                        </xsl:call-template>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>
    
    <!-- izpis imena, glede na število kazal: so lahko v tei:front -->
    <xsl:template name="nav-toc-head">
        <xsl:choose>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc']) = 1">
                <xsl:sequence select="tei:i18n('Kazalo')"/>
            </xsl:when>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='toc']) = 2">
                <xsl:sequence select="tei:i18n('Kazali')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="tei:i18n('Kazala')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- izpis imena, glede na število indeksov (krajevnih, osebnih, organizacij): so lahko v tei:back -->
    <xsl:template name="nav-index-head">
        <xsl:choose>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='index']) = 1">
                <xsl:sequence select="tei:i18n('Indeks')"/>
            </xsl:when>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:divGen[@type='index']) = 2">
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
            <!-- če je article, je lahko samo abstract -->
            <xsl:when test="ancestor-or-self::tei:TEI/tei:text[@type='article']">
                <xsl:choose>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div) = 1">
                        <xsl:sequence select="tei:i18n('Izvleček')"/>
                    </xsl:when>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div) = 2">
                        <xsl:sequence select="tei:i18n('Izvlečka')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Izvlečki')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div) = 1">
                        <xsl:sequence select="tei:i18n('Uvod')"/>
                    </xsl:when>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:div) = 2">
                        <xsl:sequence select="tei:i18n('Uvoda')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Uvodi')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- izpis imena, glede na število body/div -->
    <xsl:template name="nav-body-head">
        <xsl:choose>
            <xsl:when test="ancestor-or-self::tei:TEI/tei:text[@type='article']">
                <xsl:sequence select="tei:i18n('Besedilo članka')"/>
            </xsl:when>
            <xsl:when test="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div[@type='part']">
                <xsl:sequence select="tei:i18n('Besedilo')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div) = 1">
                        <xsl:sequence select="tei:i18n('Poglavje')"/>
                    </xsl:when>
                    <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div) = 2">
                        <xsl:sequence select="tei:i18n('Poglavji')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="tei:i18n('Poglavja')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- izpis imena, glede na število back/div -->
    <xsl:template name="nav-appendix-head">
        <xsl:choose>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix']) = 1">
                <xsl:sequence select="tei:i18n('Priloga')"/>
            </xsl:when>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='appendix']) = 2">
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
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary']) = 1">
                <xsl:sequence select="tei:i18n('Povzetek')"/>
            </xsl:when>
            <xsl:when test="count(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='summary']) = 2">
                <xsl:sequence select="tei:i18n('Povzetka')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="tei:i18n('Povzetki')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
