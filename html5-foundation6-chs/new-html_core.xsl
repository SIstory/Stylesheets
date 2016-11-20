<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei html teidocx"
    version="2.0">
    
    <xsl:template name="makeaNote">
        <xsl:variable name="identifier">
            <xsl:call-template name="noteID"/>
        </xsl:variable>
        <xsl:if test="$verbose = 'true'">
            <xsl:message>Make note <xsl:value-of select="$identifier"/></xsl:message>
        </xsl:if>
        <div class="note">
            <xsl:call-template name="makeAnchor">
                <xsl:with-param name="name" select="$identifier"/>
            </xsl:call-template>
            <p>
                <xsl:choose>
                    <xsl:when test="$footnoteBackLink = 'true'">
                        <a class="link_return" title="Pojdi nazaj k besedilu" href="#{concat($identifier,'_return')}">
                            <sup>
                                <xsl:call-template name="noteN"/>
                                <xsl:if test="matches(@n, '[0-9]')">
                                    <xsl:text>.</xsl:text>
                                </xsl:if>
                            </sup>
                        </a>
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <sup>
                            <xsl:call-template name="noteN"/>
                            <xsl:if test="matches(@n, '[0-9]')">
                                <xsl:text>.</xsl:text>
                            </xsl:if>
                            <xsl:text> </xsl:text>
                        </sup>
                    </xsl:otherwise>
                </xsl:choose>
                <span class="noteBody">
                    <xsl:apply-templates/>
                </span>
                <!--<xsl:if test="$footnoteBackLink = 'true'">
                    <xsl:text> </xsl:text>
                    <a class="link_return" title="Go back to text" href="#{concat($identifier,'_return')}">↵</a>
                </xsl:if>-->
            </p>
        </div>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>