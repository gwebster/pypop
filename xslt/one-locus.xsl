<xsl:stylesheet 
 version='1.0'
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:exsl="http://exslt.org/common"
 extension-element-prefixes="exsl">

 <xsl:import href="lib.xsl"/>
 
 <!-- select "text" as output method -->
 <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

 <!-- unique key for all loci -->
 <xsl:key name="loci" match="/meta/dataanalysis/locus" use="@name"/>

 <xsl:template name="gen-lines">
  <xsl:param name="nodes"/>
  <xsl:param name="short" select="'1'"/>

  <xsl:for-each select="$nodes">

   <xsl:variable name="begin-line">
    <xsl:value-of select="substring-before(../filename, '.')"/>
    <xsl:text>&#09;</xsl:text>
    <xsl:value-of select="translate(../populationdata/ethnic, ' ', '-')"/>
    <xsl:text>&#09;</xsl:text>
    <xsl:value-of select="translate(../populationdata/contin, ' ', '-')"/>
    <xsl:text>&#09;</xsl:text>
    <xsl:value-of select="translate(@name, '*', '')"/>
    <xsl:text>&#09;</xsl:text>
   </xsl:variable>

   <xsl:choose>
    <xsl:when test="$short='1'">
     <xsl:value-of select="$begin-line"/>
     <xsl:choose>
      <xsl:when test="allelecounts/distinctalleles">
       <xsl:value-of select="allelecounts/distinctalleles"/>
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
     </xsl:choose>
     <xsl:call-template name="newline"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:for-each select="allelecounts/allele">
      <xsl:value-of select="$begin-line"/>
      <xsl:value-of select="@name"/>
      <xsl:text>&#09;</xsl:text>
      <xsl:value-of select="frequency"/>
      <xsl:call-template name="newline"/>
     </xsl:for-each>
    </xsl:otherwise>
   </xsl:choose>
   
   
  </xsl:for-each>
 </xsl:template>

 <xsl:template match="/">

  <xsl:choose>

   <xsl:when test="element-available('exsl:document')">

    <exsl:document href="1-locus-summary.dat"
     omit-xml-declaration="yes"
     method="text">
     <xsl:text>pop&#09;ethnic&#09;region&#09;locus&#09;k</xsl:text>
     <xsl:call-template name="newline"/>
     <xsl:call-template name="gen-lines">
      <xsl:with-param name="nodes" select="/meta/dataanalysis/locus"/>
      <xsl:with-param name="short" select="'1'"/>
     </xsl:call-template>
    
    </exsl:document>

    <exsl:document href="1-locus-allele.dat"
     omit-xml-declaration="yes"
     method="text">
     <xsl:text>pop&#09;ethnic&#09;region&#09;locus&#09;allele&#09;allele.freq</xsl:text>
     <xsl:call-template name="newline"/>
     <xsl:call-template name="gen-lines">
      <xsl:with-param name="nodes" select="/meta/dataanalysis/locus"/>
      <xsl:with-param name="short" select="'0'"/>
     </xsl:call-template>
     
    </exsl:document>

    </xsl:when>

   <xsl:otherwise>
    <xsl:message>needs a processor that understands exsl elements, see http://exsl.org/
    </xsl:message>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:call-template name="newline"/>

 </xsl:template>

 
 <!-- suppress output of random text -->
 <xsl:template match="text()">
  <!--  <xsl:value-of select="."/>  -->
 </xsl:template>


</xsl:stylesheet>

<!-- 
Local variables:
mode: xml
sgml-default-dtd-file: "xsl.ced"
sgml-indent-step: 1
sgml-indent-data: 1
End:
-->