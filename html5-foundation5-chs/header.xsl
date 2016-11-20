<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="tei" 
    version="2.0">
    
    <xsl:param name="logo">
        <a href="http://sistory.si">
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace/tei:ref">
                        <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace/tei:ref"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>http://www.sistory.si</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <img src="../../../publikacije/themes/img/logos/sistory.png" alt="Zgodovina Slovenije - SIstory" title="Zgodovina Slovenije - SIstory" />
        </a>
    </xsl:param>
    
    <!-- Za statični naslov v header (samo naslovna stran index.html ima povsem svojega). -->
    <xsl:param name="naslovHeader">
        <!-- Vzamem samo prvi naslov: Ostali podnaslovi so tako in tako sebovani v kolofonu. -->
        <h1 class="glavaNaslov">
            <a href="index.html">
                <xsl:value-of select="//tei:docTitle[1]/tei:titlePart[1]"/>
            </a>
        </h1>
    </xsl:param>
    
    <xsl:template name="html-header">
        <header>
            <div class="row">
                <div class="large-3 columns hide-for-small-only glava">
                    <xsl:copy-of select="$logo"/>
                </div>
                <div class="large-9 columns">
                    <div class="row">
                        <div class="large-12 columns glava">
                            <xsl:copy-of select="$naslovHeader"/>
                        </div>
                    </div>
                    <!-- Na začetku naredimo horizontalno navigacijo, ki je pri vseh v tem templatu ustavjenih html datotekah sicer enaka,
                                 vendar je drugačna pri kazalu, indeksu in uvodu. -->
                    <div class="row">
                        <div class="large-12 columns">				
                            <nav class="top-bar" data-topbar="">
                                <ul class="title-area">
                                    <li class="name">
                                        
                                    </li>
                                    <!-- Remove the class "menu-icon" to get rid of menu icon. Take out "Menu" to just have icon alone -->
                                    <li class="toggle-topbar menu-icon"><a href="#"><span>Kazalo</span></a></li>
                                </ul>
                                <section class="top-bar-section">
                                    <ul class="left">
                                        <li class="divider"></li>
                                        <!-- Poiščemo vse možne dele publikacije -->
                                        <!-- kolofon -->
                                        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='teiHeader']">
                                            <li>
                                                <xsl:if test=".[@type='teiHeader']">
                                                    <xsl:attribute name="class">active</xsl:attribute>
                                                </xsl:if>
                                                <a href="{concat(ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='teiHeader']/@xml:id,'.html')}">
                                                    <xsl:value-of select="ancestor-or-self::tei:TEI/tei:text/tei:front/tei:divGen[@type='teiHeader']/tei:head[1]"/>
                                                </a>
                                            </li>
                                            <li class="divider"></li>
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
                                            </li>
                                            <li class="divider"></li>
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
                                            </li>
                                            <li class="divider"></li>
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
                                            </li>
                                            <li class="divider"></li>
                                        </xsl:if>
                                        <!-- viri in literatura v tei:back -->
                                        <xsl:if test="ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr']">
                                            <li>
                                                <xsl:if test=".[@type='bibliogr']">
                                                    <xsl:attribute name="class">active</xsl:attribute>
                                                </xsl:if>
                                                <!-- povezava na prvi div z bibliogr -->
                                                <a href="{concat(ancestor-or-self::tei:TEI/tei:text/tei:back/tei:div[@type='bibliogr'][1]/@xml:id,'.html')}">Bibliografija</a>
                                            </li>
                                            <li class="divider"></li>
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
                                            </li>
                                            <li class="divider"></li>
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
                                            </li>
                                            <li class="divider"></li>
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
                                            </li>
                                            <li class="divider"></li>
                                        </xsl:if>
                                    </ul>
                                </section>
                            </nav>
                        </div>
                    </div>
                    <!-- zaključek header -->
                </div>
                <hr />
            </div>
        </header>
    </xsl:template>
    
    <!-- izpis imena, glede na število kazal -->
    <xsl:template name="nav-toc-head">
        <xsl:choose>
            <xsl:when test="count(//tei:divGen[@type='toc']) = 1">Kazalo</xsl:when>
            <xsl:when test="count(//tei:divGen[@type='toc']) = 2">Kazali</xsl:when>
            <xsl:otherwise>Kazala</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- izpis imena, glede na število indeksov (krajevnih, osebnih, organizacij) -->
    <xsl:template name="nav-index-head">
        <xsl:choose>
            <xsl:when test="count(//tei:divGen[@type='index']) = 1">Indeks</xsl:when>
            <xsl:when test="count(//tei:divGen[@type='index']) = 2">Indeksa</xsl:when>
            <xsl:otherwise>Indeksi</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- izpis imena, glede na število front/div -->
    <xsl:template name="nav-front-head">
        <xsl:choose>
            <xsl:when test="count(//tei:div[parent::tei:front]) = 1">Uvod</xsl:when>
            <xsl:when test="count(//tei:div[parent::tei:front]) = 2">Uvoda</xsl:when>
            <xsl:otherwise>Uvodi</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- izpis imena, glede na število body/div -->
    <xsl:template name="nav-body-head">
        <xsl:choose>
            <xsl:when test="count(//tei:div[parent::tei:body]) = 1">Poglavje</xsl:when>
            <xsl:when test="count(//tei:div[parent::tei:body]) = 2">Poglavji</xsl:when>
            <xsl:otherwise>Poglavja</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- izpis imena, glede na število back/div -->
    <xsl:template name="nav-appendix-head">
        <xsl:choose>
            <xsl:when test="count(//tei:div[@type='appendix']) = 1">Priloga</xsl:when>
            <xsl:when test="count(//tei:div[@type='appendix']) = 2">Prilogi</xsl:when>
            <xsl:otherwise>Priloge</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- izpis imena, glede na število back/div -->
    <xsl:template name="nav-summary-head">
        <xsl:choose>
            <xsl:when test="count(//tei:div[@type='summary']) = 1">Povzetek</xsl:when>
            <xsl:when test="count(//tei:div[@type='summary']) = 2">Povzetka</xsl:when>
            <xsl:otherwise>Povzetki</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
