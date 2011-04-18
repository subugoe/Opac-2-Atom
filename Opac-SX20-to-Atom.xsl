<?xml version="1.0" encoding="UTF-8"?>
<!--
	April 2011
	Sven-S. Porst, SUB Göttingen <porst@sub.uni-goettingen.de>
-->
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/2005/Atom">

	<xsl:output indent="yes" method="xml" version="1.0" encoding="UTF-8" media-type="text"/>
	<xsl:param name="query"/>
	<xsl:param name="queryEscaped"/>
	<xsl:param name="myURL"/>
	<xsl:param name="updated"/>
	<xsl:variable name="opacURL">http://opac.sub.uni-goettingen.de/DB=1/</xsl:variable>
		
	<xsl:template match="@*|node()">
		<xsl:apply-templates select="@*|node()"/>
	</xsl:template>


	<xsl:template match="SET">
		<xsl:variable name="feedTitle">
			<xsl:text>SUB Göttingen Opac: </xsl:text>
			<xsl:value-of select="$query"/>
		</xsl:variable>
		<xsl:variable name="webURL">
			<xsl:value-of select="$opacURL"/>
			<xsl:value-of select="$queryEscaped"/>
		</xsl:variable>

		<atom:feed>
			<atom:id><xsl:value-of select="$webURL"/></atom:id>
			<atom:title><xsl:value-of select="$feedTitle"/></atom:title>
			<atom:link rel="self">
				<xsl:attribute name="href">
					<xsl:value-of select="$myURL"/>
				</xsl:attribute>
			</atom:link>
			<atom:link rel="alternate">
				<xsl:attribute name="href">
					<xsl:value-of select="$webURL"/>
				</xsl:attribute>
			</atom:link>
			<atom:updated><xsl:value-of select="$updated"/></atom:updated>
			<atom:author>
				<atom:name>SUB Göttingen Opac</atom:name>
				<atom:uri>http://opac.sub.uni-goettingen.de/</atom:uri>
			</atom:author>
			<atom:generator>Opac-Shorttitle-to-Atom.xsl</atom:generator>
	
			<xsl:apply-templates select="SHORTTITLE"/>

		</atom:feed>
	</xsl:template>


	<xsl:template match="SHORTTITLE">
		<xsl:variable name="PPN" select="@PPN"/>
		<xsl:variable name="PPNWebURL">
			<xsl:value-of select="$opacURL"/>
			<xsl:text>PPNSET?PPN=</xsl:text>
			<xsl:value-of select="$PPN"/>
		</xsl:variable>
		<xsl:variable name="bookName" select="text()"/>

		<atom:entry>
			<atom:id><xsl:value-of select="$PPNWebURL"/></atom:id>
			<atom:title><xsl:value-of select="$bookName"/></atom:title>
			<atom:link rel="alternate">
				<xsl:attribute name="href">
					<xsl:value-of select="$PPNWebURL"/>
				</xsl:attribute>
			</atom:link>
			<atom:updated><xsl:value-of select="$updated"/></atom:updated>
		</atom:entry>
	</xsl:template>


</xsl:stylesheet>
