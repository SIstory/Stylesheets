<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei" 
    version="2.0">
    
    <xsl:template match="tei:teiCorpus" mode="split">
        <xsl:variable name="BaseFile">
            <xsl:value-of select="$masterFile"/>
            <xsl:call-template name="addCorpusID"/>
        </xsl:variable>
        <xsl:if test="$verbose='true'">
            <xsl:message>TEI HTML: run start hook template teiStartHook</xsl:message>
        </xsl:if>
        <xsl:call-template name="teiStartHook"/>
        <xsl:if test="$verbose='true'">
            <xsl:message>TEI HTML in corpus splitting mode, base file is <xsl:value-of select="$BaseFile"/>
            </xsl:message>
        </xsl:if>
        <xsl:variable name="outName">
            <xsl:call-template name="outputChunkName">
                <xsl:with-param name="ident">
                    <xsl:value-of select="$BaseFile"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:if test="$verbose='true'">
            <xsl:message>Opening file <xsl:value-of select="$outName"/>
            </xsl:message>
        </xsl:if>
        <!-- vedno je index.html -->
        <xsl:variable name="datoteka" select="concat($outputDir,@xml:id,'/','index.html')"/>
        <xsl:result-document href="{$datoteka}" doctype-system="" omit-xml-declaration="yes">
            <!-- vključimo HTML5 deklaracijo, skupaj z kodo za delovanje starejših verzij Internet Explorerja -->
            <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
            <html>
                <xsl:call-template name="addLangAtt"/>
                <!-- vključimo statični head -->
                <xsl:variable name="pagetitle">
                    <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[1]/text()"/>
                </xsl:variable>
                <xsl:sequence select="tei:htmlHead($pagetitle, 2)"/>
                <body>
                    <xsl:call-template name="bodyMicroData"/>
                    <xsl:call-template name="bodyJavascriptHook"/>
                    <xsl:call-template name="bodyHook"/>
                    <!-- začetek vsebine -->
                    <div class="column row">
                        <!-- vstavim svoj header -->
                        <xsl:call-template name="html-header">
                            <xsl:with-param name="thisChapter-id">index</xsl:with-param>
                        </xsl:call-template>
                        <!--<div class="stdheader autogenerated">
                        <xsl:call-template name="stdheader">
                            <xsl:with-param name="title">
                                <xsl:apply-templates select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[1]"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </div>-->
                        <!-- v corpusBody se procesira -->
                        <xsl:call-template name="corpusBody"/>
                        <!-- če želimo procesirati ostale dokumente, primerne za znanstvene revije -->
                        <xsl:if test="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@level='j']">
                            <xsl:call-template name="teiCorpus-Journals">
                                <xsl:with-param name="corpusID" select="@xml:id"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:call-template name="stdfooter"/>
                        <xsl:call-template name="bodyEndHook"/>
                    </div>
                </body>
            </html>
        </xsl:result-document>
        <xsl:if test="$verbose='true'">
            <xsl:message>Closing file <xsl:value-of select="$outName"/>
            </xsl:message>
        </xsl:if>
        <xsl:if test="$verbose='true'">
            <xsl:message>TEI HTML: run end hook template teiEndHook</xsl:message>
        </xsl:if>
        <xsl:call-template name="teiEndHook"/>
        <!-- procesiram naprej TEI samo, če so izpolnjeni pogoji iz parametra processing-TEI-from-teiCorpus -->
        <xsl:if test="$processing-TEI-from-teiCorpus = 'true'">
            <xsl:apply-templates select="tei:TEI" mode="split"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="corpusBody">
        <!--<xsl:call-template name="mainTOC"/>-->
        <!-- naslovnica -->
        <xsl:if test="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:publisher/tei:name">
            <br />
            <p  class="naslovnicaAvtor">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:publisher/tei:name"/>
            </p>
        </xsl:if>
        <!-- naslov: Dam samo prvi naslov -->
        <h1 class="text-center">
            <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[1]"/>
        </h1>
        <br />
        <br />
        <p class="text-center">
            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='volume']">
                <xsl:sequence select="tei:i18n('volume')"/>
                <xsl:value-of select="concat(' ',tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='volume'])"/>
                <br />
            </xsl:if>
            <xsl:if test="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='issue']">
                <xsl:sequence select="tei:i18n('issue')"/>
                <xsl:value-of select="concat(' ',tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='issue'])"/>
                <br />
            </xsl:if>
            <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date"/>
        </p>
    </xsl:template>
    
    <xsl:template name="teiCorpus-Journals">
        <xsl:param name="corpusID"/>
        <xsl:if test="$write-teiCorpus-teiHeader='true'">
            <!-- vedno je teiHeader.html -->
            <xsl:variable name="datoteka" select="concat($outputDir,$corpusID,'/','teiHeader.html')"/>
            <xsl:result-document href="{$datoteka}" doctype-system="" omit-xml-declaration="yes">
                <!-- vključimo HTML5 deklaracijo, skupaj z kodo za delovanje starejših verzij Internet Explorerja -->
                <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
                <html>
                    <xsl:call-template name="addLangAtt"/>
                    <!-- vključimo statični head -->
                    <xsl:variable name="pagetitle">
                        <xsl:sequence select="tei:i18n('teiHeader')"/>
                    </xsl:variable>
                    <xsl:sequence select="tei:htmlHead($pagetitle, 2)"/>
                    <body>
                        <xsl:call-template name="bodyMicroData"/>
                        <xsl:call-template name="bodyJavascriptHook"/>
                        <xsl:call-template name="bodyHook"/>
                        <!-- začetek vsebine -->
                        <div class="column row">
                            <!-- vstavim svoj header -->
                            <xsl:call-template name="html-header">
                                <xsl:with-param name="thisChapter-id">teiHeader</xsl:with-param>
                            </xsl:call-template>
                            <h2>
                                <xsl:sequence select="tei:i18n('teiHeader')"/>
                            </h2>
                            <xsl:apply-templates select="tei:teiHeader"/>
                            <xsl:call-template name="stdfooter"/>
                            <xsl:call-template name="bodyEndHook"/>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:if>
        <xsl:if test="$write-teiCorpus-cip='true'">
            <!-- vedno je impressum.html -->
            <xsl:variable name="datoteka" select="concat($outputDir,$corpusID,'/','impressum.html')"/>
            <xsl:result-document href="{$datoteka}" doctype-system="" omit-xml-declaration="yes">
                <!-- vključimo HTML5 deklaracijo, skupaj z kodo za delovanje starejših verzij Internet Explorerja -->
                <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
                <html>
                    <xsl:call-template name="addLangAtt"/>
                    <!-- vključimo statični head -->
                    <xsl:variable name="pagetitle">
                        <xsl:sequence select="tei:i18n('impressum')"/>
                    </xsl:variable>
                    <xsl:sequence select="tei:htmlHead($pagetitle, 2)"/>
                    <body>
                        <xsl:call-template name="bodyMicroData"/>
                        <xsl:call-template name="bodyJavascriptHook"/>
                        <xsl:call-template name="bodyHook"/>
                        <!-- začetek vsebine -->
                        <div class="column row">
                            <!-- vstavim svoj header -->
                            <xsl:call-template name="html-header">
                                <xsl:with-param name="thisChapter-id">cip</xsl:with-param>
                            </xsl:call-template>
                            <h2>
                                <xsl:sequence select="tei:i18n('impressum')"/>
                            </h2>
                            <xsl:apply-templates select="tei:teiHeader/tei:fileDesc" mode="kolofon"/>
                            <xsl:call-template name="stdfooter"/>
                            <xsl:call-template name="bodyEndHook"/>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:if>
        <xsl:if test="$write-teiCorpus-toc_titleAuthor='true'">
            <!-- vedno je impressum.html -->
            <xsl:variable name="datoteka" select="concat($outputDir,$corpusID,'/','tocJournal.html')"/>
            <xsl:result-document href="{$datoteka}" doctype-system="" omit-xml-declaration="yes">
                <!-- vključimo HTML5 deklaracijo, skupaj z kodo za delovanje starejših verzij Internet Explorerja -->
                <xsl:value-of select="$HTML5_declaracion" disable-output-escaping="yes"/>
                <html>
                    <xsl:call-template name="addLangAtt"/>
                    <!-- vključimo statični head -->
                    <xsl:variable name="pagetitle">
                        <xsl:sequence select="tei:i18n('tocJournal')"/>
                    </xsl:variable>
                    <xsl:sequence select="tei:htmlHead($pagetitle, 2)"/>
                    <body>
                        <xsl:call-template name="bodyMicroData"/>
                        <xsl:call-template name="bodyJavascriptHook"/>
                        <xsl:call-template name="bodyHook"/>
                        <!-- začetek vsebine -->
                        <div class="column row">
                            <!-- vstavim svoj header -->
                            <xsl:call-template name="html-header">
                                <xsl:with-param name="thisChapter-id">tocJournal</xsl:with-param>
                            </xsl:call-template>
                            <h2>
                                <xsl:sequence select="tei:i18n('tocJournal-title')"/>
                            </h2>
                            <xsl:for-each-group select="tei:TEI/tei:text" group-by="@n">
                                <div class="subchapter">
                                    <h3>
                                        <span class="head" itemprop="head">
                                            <xsl:value-of select="current-grouping-key()"/>
                                        </span>
                                    </h3>
                                    <ul class="toc">
                                        <xsl:for-each select="current-group()">
                                            <li class="toc" itemscope="" itemtype="https://schema.org/CreativeWork">
                                                <xsl:if test="tei:front/tei:titlePage/tei:docAuthor">
                                                    <xsl:for-each select="tei:front/tei:titlePage/tei:docAuthor">
                                                        <xsl:value-of select="."/>
                                                        <xsl:if test="position() != last()">
                                                            <xsl:text>, </xsl:text>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                    <xsl:text>, </xsl:text>
                                                </xsl:if>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:choose>
                                                            <xsl:when test="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID'][starts-with(.,'sistory.')]">
                                                                <xsl:value-of select="concat('http://hdl.handle.net/11686/',substring-after(ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID'][starts-with(.,'sistory.')],'sistory.'))"/>
                                                            </xsl:when>
                                                            <xsl:when test="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
                                                                <xsl:variable name="teiID" select="ancestor::tei:TEI/@xml:id"/>
                                                                <xsl:variable name="sistoryID">
                                                                    <xsl:for-each select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='sistory']">
                                                                        <xsl:variable name="idno" select="."/>
                                                                        <xsl:for-each select="tokenize(@corresp,' ')">
                                                                            <xsl:if test="substring-after(.,'#') = $teiID">
                                                                                <xsl:value-of select="$idno"/>
                                                                            </xsl:if>
                                                                        </xsl:for-each>
                                                                    </xsl:for-each>
                                                                </xsl:variable>
                                                                <xsl:value-of select="concat('http://hdl.handle.net/11686/',$sistoryID)"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:choose>
                                                                    <xsl:when test="ancestor::tei:TEI/tei:fileDesc/tei:publicationStmt/tei:pubPlace/tei:ref">
                                                                        <!-- upoštevamo samo prvo povezavo -->
                                                                        <xsl:value-of select="ancestor::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace[tei:ref][1]/tei:ref"/>
                                                                    </xsl:when>
                                                                    <xsl:otherwise>
                                                                        <xsl:text>http://www.sistory.si</xsl:text>
                                                                    </xsl:otherwise>
                                                                </xsl:choose>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:attribute>
                                                    <xsl:for-each select="tei:front/tei:titlePage/tei:docTitle/tei:titlePart">
                                                        <xsl:value-of select="."/>
                                                        <xsl:if test="position() != last()">
                                                            <xsl:text>: </xsl:text>
                                                        </xsl:if>
                                                    </xsl:for-each>                    
                                                </a>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </div>
                            </xsl:for-each-group>
                            <xsl:call-template name="stdfooter"/>
                            <xsl:call-template name="bodyEndHook"/>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:if>
    </xsl:template>
    
    
    
</xsl:stylesheet>