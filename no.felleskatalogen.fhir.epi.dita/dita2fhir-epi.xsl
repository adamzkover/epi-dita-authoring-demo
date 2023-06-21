<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://hl7.org/fhir" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="3.0">

    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="map">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="topicgroup">
        <xsl:variable name="resourceType" select="data[@name = 'resourceType']/@value"/>
        <xsl:choose>
            <xsl:when test="$resourceType = 'Bundle'">
                <Bundle xmlns="http://hl7.org/fhir">
                    <identifier>
                        <system value="{data[@name = 'identifier']/data[@name = 'system']/@value}"/>
                        <value value="{data[@name = 'identifier']/data[@name = 'value']/@value}"/>
                    </identifier>
                    <type value="document"/>
                    <timestamp value="{data[@name = 'timestamp']/@value}"/>
                    <xsl:for-each select="topicgroup">
                        <entry>
                            <fullUrl value="urn:uuid:{data[@name = 'id']/@value}"/>
                            <resource>
                                <xsl:apply-templates select="."/>
                            </resource>
                        </entry>
                    </xsl:for-each>
                </Bundle>
            </xsl:when>
            <xsl:when test="$resourceType = 'Composition'">
                <Composition>
                    <id value="{data[@name = 'id']/@value}"/>
                    <meta>
                        <profile value="http://hl7.org/fhir/uv/emedicinal-product-info/StructureDefinition/Composition-uv-epi"/>
                    </meta>
                    <language value="{data[@name = 'language']/@value}"/>
                    <identifier>
                        <system value="{data[@name = 'identifier']/data[@name = 'system']/@value}"/>
                        <value value="{data[@name = 'identifier']/data[@name = 'value']/@value}"/>
                    </identifier>
                    <status value="final"/>
                    <type>
                        <coding>
                            <system value="https://spor.ema.europa.eu/rms"/>
                            <code value="100000155538"/>
                            <display value="Package Leaflet"/>
                        </coding>
                    </type>
                    <subject>
                        <identifier>
                            <system value="{data[@name = 'subjectIdentifier']/data[@name = 'system']/@value}"/>
                            <value value="{data[@name = 'subjectIdentifier']/data[@name = 'value']/@value}"/>
                        </identifier>
                    </subject>
                    <date value="{data[@name = 'date']/@value}"/>
                    <author>
                        <reference value="Organization/{data[@name = 'authorId']/@value}"/>
                    </author>
                    <title value="{data[@name = 'title']/@value}"/>
                    <xsl:apply-templates/>
                </Composition>
            </xsl:when>
            <xsl:when test="$resourceType = 'Organization'">
                <Organization>
                    <id value="{data[@name = 'id']/@value}"/>
                    <meta>
                        <profile value="http://hl7.org/fhir/uv/emedicinal-product-info/StructureDefinition/Organization-uv-epi"/>
                    </meta>
                    <identifier>
                        <system value="{data[@name = 'identifier']/data[@name = 'system']/@value}"/>
                        <value value="{data[@name = 'identifier']/data[@name = 'value']/@value}"/>
                    </identifier>
                    <name value="{data[@name = 'name']/@value}"/>
                </Organization>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="topicref">
        <xsl:param name="level" select="number('1')" as="xs:double"/>
        <xsl:apply-templates select="document(@href)">
            <xsl:with-param name="level" select="$level"/>
            <xsl:with-param name="subSections" select="topicref"/>
            <xsl:with-param name="sectionId" select="data[@name = 'sectionId']"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="topic">
        <xsl:param name="level"/>
        <xsl:param name="subSections"/>
        <xsl:param name="sectionId"/>
        <xsl:choose>
            <xsl:when test="$sectionId">
                <section>
                    <xsl:apply-templates select="title" mode="fhir"/>
                    <code>
                        <coding>
                            <system value="{$sectionId/data[@name = 'system']/@value}"/>
                            <code value="{$sectionId/data[@name = 'code']/@value}"/>
                        </coding>
                    </code>
                    <text>
                        <status value="additional"/>
                        <div xmlns="http://www.w3.org/1999/xhtml">
                            <xsl:apply-templates>
                                <xsl:with-param name="level" select="$level" as="xs:double"/>
                            </xsl:apply-templates>
                            <xsl:apply-templates select="$subSections[not(data[@name = 'sectionId'])]">
                                <xsl:with-param name="level" select="number($level + 1)" as="xs:double"/>
                            </xsl:apply-templates>
                        </div>
                    </text>
                    <xsl:apply-templates select="$subSections[data[@name = 'sectionId']]">
                        <xsl:with-param name="level" select="number($level + 1)" as="xs:double"/>
                    </xsl:apply-templates>
                </section>
            </xsl:when>
            <xsl:otherwise>
                <div xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:apply-templates>
                        <xsl:with-param name="level" select="$level" as="xs:double"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="$subSections">
                        <xsl:with-param name="level" select="number($level + 1)" as="xs:double"/>
                    </xsl:apply-templates>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="topic/title" mode="fhir">
        <title value="{.}"/>
    </xsl:template>

    <xsl:template match="topic/title">
        <xsl:param name="level"/>
        <xsl:element name="{concat('h', $level)}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="body">
        <div xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="p | ol | ul | li">
        <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*"/>

</xsl:stylesheet>
