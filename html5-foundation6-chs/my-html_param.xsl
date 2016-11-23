<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="tei"
    version="2.0">
    
    <!-- generična pot do css in js -->
    <!--<xsl:param name="path-general">../../../</xsl:param>-->
    <xsl:param name="path-general">http://www2.sistory.si/</xsl:param>
    
    <!-- za divGen[@type='teiHeader']: če je $element-gloss-teiHeader true,
        se izpišejo gloss imena za elemente, drugače je name() elementa -->
    <xsl:param name="element-gloss-teiHeader">true</xsl:param>
    <!-- za divGen[@type='teiHeader']: določi se jezik izpisa za gloss elementa, lahko samo za:
         - sl
         - en
    -->
    <xsl:param name="element-gloss-teiHeader-lang">sl</xsl:param>
    
    <!-- V html/head izpisani metapodatki -->
    <xsl:param name="description"></xsl:param>
    <xsl:param name="keywords"></xsl:param>
    <xsl:param name="title"></xsl:param>
    
    <xsl:param name="HTML5_declaracion"><![CDATA[<!DOCTYPE html>]]></xsl:param>
    
</xsl:stylesheet>
