<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="tei" 
    version="2.0">
    
    <xsl:template name="off-canvas">
        <xsl:param name="thisChapter-id"/>
        
        <!-- levi off-canvas za glavna poglavja od tablic navzgor -->
        <div class="medium-3 columns">
            <xsl:choose>
                <!-- če je:
                       - več kot en div znotraj front, body
                       - več kot en tei:divGen[@type='toc']
                       - več kot en tei:divGen[@type='index']
                       - več kot en tei:div[@type='bibliogr']
                       - več kot en tei:div[@type='appendix']
                       - več kot en tei:div[@type='summary']
                -->
                <xsl:when test="(parent::tei:front/tei:divGen[@type='toc'][2] and self::tei:divGen[@type='toc']) or
                                (parent::tei:front/tei:div[2] and self::tei:div[parent::tei:front]) or
                                (parent::tei:body/tei:div[2] and self::tei:div[parent::tei:body]) or 
                                (parent::tei:back/tei:div[@type='bibliogr'][2] and self::tei:div[@type='bibliogr']) or
                                (parent::tei:back/tei:div[@type='appendix'][2] and self::tei:div[@type='appendix']) or
                                (parent::tei:back/tei:div[@type='summary'][2] and self::tei:div[@type='summary']) or
                                (parent::tei:back/tei:divGen[@type='index'][2] and self::tei:divGen[@type='index'])">
                    <nav class="tab-bar">
                        <section class="left-small">
                            <a class="left-off-canvas-toggle menu-icon" ><span></span></a>
                        </section>
                        <section class="right tab-bar-section">
                            <h1 class="title">Poglavja</h1>
                        </section>
                    </nav>
                </xsl:when>
                <xsl:otherwise>
                    <p></p>
                </xsl:otherwise>
            </xsl:choose>
        </div>
        <!-- na sredi iskalnik, ki se prikaže samo za tablice -->
        <div class="medium-5 columns show-for-medium-only">
            <form action="search.html">
                <div class="row collapse">
                    <div class="small-10 columns">
                        <input type="text" name="q" class="tipue_search_input" placeholder="Vaš iskalni niz"/>
                    </div>
                    <div class="small-2 columns">
                        <input type="button" class="tipue_search_button" onclick="this.form.submit();"/>
                    </div>
                </div>
            </form>
        </div>
        <!-- na sredi iskalnik, ki se prikaže za večje ekrane -->
        <div class="medium-6 columns show-for-large-up">
            <form action="search.html">
                <div class="row collapse">
                    <div class="small-10 columns">
                        <input type="text" name="q" class="tipue_search_input" placeholder="Vaš iskalni niz"/>
                    </div>
                    <div class="small-2 columns">
                        <input type="button" class="tipue_search_button" onclick="this.form.submit();"/>
                    </div>
                </div>
            </form>
        </div>
        <!-- desni off-canvas za podpoglavja znotraj posamezne spletne strani poglavja,
                                 ki se pokažejo samo za tablice -->
        <!-- prikaže samo v primeru, če poglavja vsebujejo podpoglavja -->
        <xsl:if test="tei:div[@type='subchapter']">
            <div class="medium-4 columns show-for-medium-only">
                <nav class="tab-bar">
                    <section class="right-small">
                        <a class="right-off-canvas-toggle menu-icon" ><span></span></a>
                    </section>
                    <section class="left tab-bar-section">
                        <h1 class="title">Podpoglavja</h1>
                    </section>
                </nav>
            </div>
        </xsl:if>
        <!-- desni off-canvas za podpoglavja znotraj posamezne spletne strani poglavja,
                                 ki se pokažejo na večjih ekranih -->
        <!-- prikaže samo v primeru, če poglavja vsebujejo podpoglavja -->
        <xsl:if test="tei:div[@type='subchapter']">
            <div class="medium-3 columns show-for-large-up">
                <nav class="tab-bar">
                    <section class="right-small"><a class="right-off-canvas-toggle menu-icon"><span></span></a></section>
                    <section class="left tab-bar-section">
                        <h1 class="title">Podpoglavja</h1>
                    </section>
                </nav>
            </div>
        </xsl:if>
        <!-- desni off-canvas za podpoglavja znotraj posamezne spletne strani poglavja,
                                 ki se pokažejo na telefonih (malih ekranih) -->
        <!-- prikaže samo v primeru, če poglavja vsebujejo podpoglavja -->
        <xsl:if test="tei:div[@type='subchapter']">
            <div class="medium-3 large-offset-6 columns hide-for-medium-up">
                <nav class="tab-bar">
                    <section class="right-small"><a class="right-off-canvas-toggle menu-icon"><span></span></a></section>
                    <section class="left tab-bar-section">
                        <h1 class="title">Podpoglavja</h1>
                    </section>
                </nav>
            </div>
        </xsl:if>
        <!-- iskalnik na telefonih ločimo od zgornjih off-canvas s prazno vrstico -->
        <div class="row hide-for-medium-up">
            <div class="small-12 columns">
                <br/>
            </div>
        </div>
        <!-- iskalnik na telefonih -->
        <form action="search.html">
            <div class="row collapse hide-for-medium-up">
                <div class="small-10 columns">
                    <input type="text" name="q" class="tipue_search_input" placeholder="Vaš iskalni niz"/>
                </div>
                <div class="small-2 columns">
                    <input type="button" class="tipue_search_button" onclick="this.form.submit();"/>
                </div>
            </div>
        </form>
        
        <aside class="left-off-canvas-menu">
            <ul class="off-canvas-list">
                <!-- navigacija za dokumente -->
                <xsl:choose>
                    <!-- za kazala -->
                    <xsl:when test="parent::tei:front and self::tei:divGen[@type='toc']">
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
                    </xsl:when>
                    <!-- za uvodna poglavja -->
                    <xsl:when test="parent::tei:front and self::tei:div">
                        <xsl:for-each select="//tei:front/tei:div">
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
                    </xsl:when>
                    <!-- za glavno vsebino -->
                    <xsl:when test="parent::tei:body">
                        <xsl:for-each select="//tei:body/tei:div">
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
                    </xsl:when>
                    <!-- za priloge -->
                    <xsl:when test="parent::tei:back and self::tei:div[@type='appendix']">
                        <xsl:for-each select="//tei:back/tei:div[@type='appendix']">
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
                    </xsl:when>
                    <!-- za bibliografijo -->
                    <xsl:when test="parent::tei:back and self::tei:div[@type='bibliogr']">
                        <xsl:for-each select="//tei:back/tei:div[@type='bibliogr']">
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
                    </xsl:when>
                    <!-- za povzetke -->
                    <xsl:when test="parent::tei:back and self::tei:div[@type='summary']">
                        <xsl:for-each select="//tei:back/tei:div[@type='summary']">
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
                    </xsl:when>
                    <!-- za indekse (krajevni, imenski, organizacij) -->
                    <xsl:when test="parent::tei:back and self::tei:divGen[@type='index']">
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
                    </xsl:when>
                </xsl:choose>
            </ul>
        </aside><!-- kolec vsebine levega off-canvas -->
        
        <!-- začetek vsebine desnega off-canvas (podpoglavja znotraj posamezne spletne strani -->
        <!-- prikaže samo v primeru, če poglavja vsebujejo podpoglavja -->
        <xsl:if test="tei:div[@type='subchapter']">
            <aside class="right-off-canvas-menu">
                <ul class="off-canvas-list">
                    <xsl:for-each select="tei:div[@type='subchapter']">
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:variable name="this-subchapterID" select="@xml:id"/>
                                    <xsl:value-of select="concat('#',$this-subchapterID)"/>
                                </xsl:attribute>
                                <xsl:value-of select="tei:head"/>
                            </a>
                        </li>
                    </xsl:for-each>
                </ul>
            </aside><!-- konec vsebine desnega off-canvas -->
        </xsl:if>
        
    </xsl:template>
    
</xsl:stylesheet>