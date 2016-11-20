<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="tei"
    version="2.0">
    
    
    <!-- V html/head izpisani metapodatki -->
    <xsl:param name="description"></xsl:param>
    <xsl:param name="keywords">tekstilna industrija, postkomunizem, Slovenija, tekstilni delavci, družbeni položaj, družbene spremembe, antropologija, postsocializem, spomini</xsl:param>
    <xsl:param name="title">Labirinti postsocializma</xsl:param>
    
    <!-- VPIŠI statični naslov za  naslovno stran index.html -->
    <xsl:param name="naslovHeaderIndex">
        <h1 class="glavaNaslov">Publikacija na portalu <a href="http://www.sistory.si">SIstory</a></h1>
    </xsl:param>
    
    <xsl:param name="HTML5_declaracion"><![CDATA[<!DOCTYPE html>
<!--[if IE 9]><html class="lt-ie10" lang="sl" > <![endif]-->]]></xsl:param>
    
</xsl:stylesheet>
