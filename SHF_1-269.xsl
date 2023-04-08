<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output encoding="UTF-8" indent="yes" method="html"/>
    
    <!-- Voici la feuille de style utilisée pour transformer le devoir original de TEI 
    en petit site internet-->
    
    <!-- On commence par la déclaration des variables utilisées pour nommer les fichiers de sortis -->
    
    <xsl:variable name="dossier_rendu" select="concat('rendu','/')"/>
    <xsl:variable name="extension" select="'html'"/>
    
    <xsl:variable name="chemin_information" select="concat('info','.',$extension)"/>
    <xsl:variable name="chemin_accueil" select="concat('accueil','.',$extension)"/>
    <xsl:variable name="chemin_index" select="concat('index','.',$extension)"/>
    <xsl:variable name="chemin_lem" select="concat('lem','.',$extension)"/>
    
    
    
    <!-- Ici on appel une à une les méthodes qui correspondent chacune à un fichier de sortie-->
    
    <xsl:template match="/">
        <xsl:call-template name="information"/>
        <xsl:call-template name="accueil"/>
        <xsl:call-template name="index"/>
        <xsl:call-template name="lem"/>
        <xsl:call-template name="temoin"/>
        <xsl:call-template name="css"/>
    </xsl:template>
    
    <!-- Déclaration de deux variables au format HTML qu'on utilisera dans chacun des fichiers de rendu -->
    
    <xsl:variable name="header">
        <header>
            <title>Encodage Critique du SHF 1-269</title>
            <link rel="stylesheet" href="critique.css"/>
        </header>
    </xsl:variable>
    
    <xsl:variable name="footer">
        <footer>
            <div class="footer">
                <a href="{$chemin_accueil}">Accueil</a>
                <a href="{$chemin_index}">Index des personnages et lieux</a>
                <a href="{$chemin_information}">Information sur l'encodage</a>
                <a href="{$chemin_lem}">Lem</a>
            </div>
        </footer>
    </xsl:variable>
    
    <!-- Template pour l'html information -->
    
    <xsl:template name="information">
        <xsl:result-document href="{concat($dossier_rendu,$chemin_information)}" method="html">
            <html>
                <body>
                <xsl:copy-of select="$header"/>
                    <div class="body">
                        <!-- On extrait les informations du TEI Header et principalement du titleStmt pour faire cette page information -->
                        <h1>Information</h1>
                        <p>Encodage en XML et transformation en HTML par Florian Langelé dans le cadre des cours de TEI et de XSLT de l'Ecole des Chartes.</p>
                        <p>L'édition numérique des textes à d'abord été réalisé à l'aide de <a><xsl:attribute name="href"><xsl:value-of select="//titleStmt//respStmt/orgName/@ref"/></xsl:attribute><xsl:value-of select="//titleStmt/respStmt/orgName"/></a></p>
                        <p>L'oeuvre originale est tirée des <xsl:value-of select="//titleStmt/title"/> de <xsl:value-of select="//titleStmt/author"/>.</p>
                        <p>Ci dessous la liste des <xsl:value-of select="count(//encodingDesc/p/list/item)"/> types différents de variations retenus dans l'analyse critique.</p>
                        
                        <!-- On reprend à l'identique, mais dans une liste HTML, les items qui expliquent les différentes variations -->
                        <ul>
                            <xsl:for-each-group select="//encodingDesc//list/item" group-by="@xml:id">
                                <li><xsl:value-of select="current-grouping-key()"/> : <xsl:value-of select="."/></li>
                            </xsl:for-each-group>
                        </ul>
                    </div>
                <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <!-- Template pour l'html accueil -->
    
    <xsl:template name="accueil">
        <xsl:result-document href="{concat($dossier_rendu,$chemin_accueil)}" method="html">
            <html>
                <body>
                <xsl:copy-of select="$header"/>
                    <body>
                        <div class="body">
                            <h1>Accueil</h1>
                            <h4>Présentation du rendu en HTML de l'encodage numérique du passage de la Blanchetaque, SHF 1-269 par Jean Froissart.</h4>
                            <p>Il y a 4 témoins différents qui ont été utilisé pour cet encodage que vous pouvez voir ci-dessous. Un code couleur a été utilisé pour illustrer les variations entre le témoin choisi et le lem. Vous pouvez survoler chacune de ces informations pour avoir plus d'information.</p>
                            <ul>
                                <!-- Pour chacun des témoins dans le TEI on génère un lien vers son document de sorti (on connait le chemin, qui est au format ville.html) -->
                                <xsl:for-each select="//witness">
                                    <li>
                                    <a href="{concat(.//msIdentifier//settlement,'.',$extension)}">
                                        <xsl:value-of select="concat(.//settlement,' ',.//idno)"/>
                                    </a></li>
                                </xsl:for-each>
                            </ul>
                        </div>
                    </body>
                <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <!-- Template pour l'html index -->
    
    <xsl:template name="index">
        <xsl:result-document href="{concat($dossier_rendu,$chemin_index)}" method="html">
            <html>
                <body>
                    <xsl:copy-of select="$header"/>
                        <div class="body">
                            <!-- Index qui va lister les personnages et lieux qui sont déjà identifié dans le profileDesc -->
                            <h1>Index</h1>
                            <h3>Listes des personnages et lieux et leurs différentes écritures </h3>
                            <!-- On aurait pu réunir les deux boucles en une mais comme ça c'est plus clair -->
                            <xsl:for-each select="//profileDesc//person">
                                <p class="index">
                                    <!-- On indique d'abord le nom contemporain et on indique ensuite les différents types presents dans le texte -->
                                    <xsl:value-of select=".//persName[@type='contemporary-name' or not(@type)]"/> : 
                                    <!-- on appelle un template spécial pour les persName placeName dans l'index qu'on voit juste ci dessous-->
                                    <xsl:apply-templates select=".//persName[@type='text-name']" mode="index"/>
                                </p>
                            </xsl:for-each>
                            <xsl:for-each select="//profileDesc//place">
                                <p class="index">
                                    <!-- Même chose ici avec la différence que si il n'y a pas de text-name identifié on indique Pas de variation -->
                                    <xsl:value-of select=".//placeName[@type='contemporary-name' or not(@type)]"/> : 
                                     <xsl:choose>
                                         <xsl:when test=".//placeName/@type = 'text-name'">
                                             <xsl:apply-templates select=".//placeName[@type='text-name']" mode="index"/>
                                         </xsl:when>
                                         <xsl:otherwise><span class="text_name">Pas de variation</span></xsl:otherwise>
                                     </xsl:choose>
                                </p>
                            </xsl:for-each>
                        </div>
                <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <!-- Pour chaque variation identifiée on la met dans une balise span -->
    <xsl:template mode="index" match="//persName[@type='text-name'] | //placeName[@type='text-name']">
        <span class="text_name"><xsl:apply-templates mode="index"/></span>
    </xsl:template>
    
    <!-- Et chaque changement est mis entre parenthèse avec un lien sur le premier temoin identifié qui a cette variation dans son texte -->
    <xsl:template mode="index" match="//app">
        <!-- Petite règle spéciale pour le rdgGrp qui n'apparait qu'une fois -->
        (<xsl:for-each select="./*[not(self::rdgGrp)] | ./rdgGrp/rdg">
            <xsl:variable name="temoin" select="./@wit"/>
            <a><xsl:attribute name="href"><xsl:value-of select="concat(//witness[contains($temoin,@xml:id)][1]//settlement,'.',$extension)"/></xsl:attribute><xsl:apply-templates/></a>
            <xsl:if test="position()!=last()">, </xsl:if>
        </xsl:for-each>)
    </xsl:template>
    
    <!-- Template pour l'html lem -->
    
    <!-- On va faire suivre chacun des templates suivants avec un attribut qui identifiera quel est le fichier de rendu le lem ou bien un des témoins -->
    <xsl:template name="lem">
        <xsl:result-document href="{concat($dossier_rendu,$chemin_lem)}" method="html">
            <html>
                <body>
                <xsl:copy-of select="$header"/>
                    <div class="body">
                        <h1>Lem</h1>
                        <xsl:apply-templates select="//body">
                            <xsl:with-param name="temoin" select="'lem'"/>
                        </xsl:apply-templates>
                    </div>
                <xsl:copy-of select="$footer"/>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template> 
    
    <!-- Template pour l'html des témoins -->
    
    <xsl:template name="temoin">
        <xsl:for-each select="//witness">
            <xsl:variable name="temoin"><xsl:value-of select="concat('#',./@xml:id)"/></xsl:variable>
            <xsl:result-document href="{concat($dossier_rendu,.//msIdentifier//settlement,'.',$extension)}">
                <html>
                    <body>
                    <xsl:copy-of select="$header"/>
                        <div class="body">
                            <!-- Quelques informations sur les témoins extraits du TEI Header -->
                            <h2>Témoin de <xsl:value-of select=".//msIdentifier//settlement"/></h2>
                            <p>Le témoin <a><xsl:attribute name="href"><xsl:value-of select="concat(.//settlement,'.',$extension)"/></xsl:attribute><xsl:value-of select=".//settlement | .//idno"/></a> est actuellement conservé dans la <xsl:value-of select=".//institution"/> à <xsl:value-of select=".//settlement"/>. Il est composé de <xsl:value-of select=".//extent"/> sur <xsl:value-of select=".//support"/>. Son origine est estimé à <xsl:value-of select=".//origDate"/>.</p>
                            <p>Pour voir d'avantage d'information sur ce manuscrit vous pouvez suivre le lien suivant -> <a><xsl:attribute name="href"><xsl:value-of select=".//adminInfo//ref/@target"/></xsl:attribute><xsl:value-of select=".//adminInfo//ref"/></a></p>
                            <!-- Le texte avec l'attribut temoin qui va descendre tout en bas de l'arbre -->
                            <h3>Texte</h3>
                            <xsl:apply-templates select="//body">
                                <xsl:with-param name="temoin" select="$temoin"/>
                            </xsl:apply-templates>
                        </div>
                    <xsl:copy-of select="$footer"/>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Début des règles pour les sous catégories -->
    
    <xsl:template match="//body">
        <xsl:param name="temoin"/>
        <xsl:apply-templates>
            <xsl:with-param name="temoin" select="$temoin"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="//body/head">
        <xsl:param name="temoin"/>
        <h4>
            <xsl:apply-templates>
                <xsl:with-param name="temoin" select="$temoin"/>
            </xsl:apply-templates>
        </h4>
    </xsl:template>
    
    <xsl:template match="//body/p">
        <xsl:param name="temoin"/>
            <p class="edition">
                <xsl:apply-templates>
                    <xsl:with-param name="temoin" select="$temoin"/>
                </xsl:apply-templates>
            </p>
    </xsl:template>
    
    <xsl:template match="//body//app">
        <xsl:param name="temoin"/>
        <xsl:apply-templates>
            <!-- On appelle tous les enfants peu importe la valeur de $temoin, on règle les conditions dans les régles qui suivent directement -->
            <xsl:with-param name="temoin" select="$temoin"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="//body//rdg">
        <xsl:param name="temoin"></xsl:param>
        <!-- On récupère la valeur de corresp qui indique le type de variation par rapport au lem -->
        <xsl:variable name="type">
            <xsl:if test="./@corresp">
                <xsl:value-of select="replace(./@corresp,'#','')"/>
            </xsl:if>
            <xsl:if test="./ancestor::*/@corresp">
                <xsl:value-of select="replace(./ancestor::app/@corresp,'#','')"/>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <!-- On appelle tous les enfants à chaque fois donc il faut vérifier que le temoin est bien le bon  -->
            <xsl:when test="contains(./@wit,$temoin)">
                <span>
                    <xsl:attribute name="title">Variation de type : <xsl:value-of select="$type"/> (<xsl:value-of select="./preceding::lem[1]"/>)
                    </xsl:attribute>
                    <xsl:attribute name="class">
                        <xsl:value-of select="$type"/>
                    </xsl:attribute>
                    <!-- On applique les templates à tous les enfants de rdg -->
                    <xsl:apply-templates select=".[contains(@wit,$temoin)]/node()">
                        <xsl:with-param name="temoin" select="$temoin"/>
                    </xsl:apply-templates>
                    <!-- Si il n'y a rien dans la balise rdg on met un ? pour représenter la variation-->
                    <xsl:if test="count(./node())=0">?</xsl:if>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Seule solution trouvée pour faire apparaitre les lacunes j'aurai pu essayer de reprendre toute la logique en ne fonctionnant non pas par
    childrens dans le p de body mais par following siblings chaque template selectionnant son frère mais après quelques tests peu concluant j'ai abandonné car je suis déjà en retard-->
    <xsl:template match="//lacunaStart"><xsl:param name="temoin"/><xsl:if test="contains(./@wit,$temoin)"><span class="lacune"> [.DEBUT LACUNE</span></xsl:if></xsl:template>
    <xsl:template match="//lacunaEnd"><xsl:param name="temoin"/><xsl:if test="contains(./@wit,$temoin)"><span class="lacune">FIN LACUNE.] </span></xsl:if></xsl:template>
    
    <xsl:template match="//body//lem">
        <xsl:param name="temoin"></xsl:param>
        <xsl:choose>
            <!-- Si on est pas dans le document de sorti lem alors on renvoie simplement le texte -->
            <xsl:when test="$temoin!='lem'">
                <xsl:apply-templates select=".[contains(@wit,$temoin)]/node()">
                    <xsl:with-param name="temoin" select="$temoin"/>
                </xsl:apply-templates>
            </xsl:when>
            <!-- Sinon on va afficher grace à l'attribut title les variations qu'on peut trouver dans les différents témoins pour ce bout de texte -->
            <xsl:otherwise>
                <span class="lem"><xsl:attribute name="title"><xsl:for-each select="following-sibling::*">Témoin <xsl:value-of select="replace(./@wit,'#','')"/> : <xsl:value-of select="."/><xsl:if test="not(./text())">Pas présent dans ces témoins</xsl:if><xsl:text>&#xA;</xsl:text></xsl:for-each></xsl:attribute><xsl:apply-templates><xsl:with-param name="temoin" select="$temoin"></xsl:with-param></xsl:apply-templates></span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Création dans lien vers l'index pour chaque nom de personne ou lieu dans le texte-->
    <xsl:template match="//body//persName">
        <xsl:param name="temoin"/>
        <a href="{$chemin_index}" class="noms">
            <xsl:apply-templates>
                <xsl:with-param name="temoin" select="$temoin"/>
            </xsl:apply-templates>
        </a>
    </xsl:template>
    
    <xsl:template match="//body//placeName">
        <xsl:param name="temoin"/>
        <a href="{$chemin_index}" class="lieux">
            <xsl:apply-templates>
                <xsl:with-param name="temoin" select="$temoin"/>
            </xsl:apply-templates>
        </a>
    </xsl:template>
    
    <!-- Suppression des sauts de lignes intempestifs dans le texte et des espaces trop nombreux à cause de la forme de l'encodage original -->
    <!-- Clairement pas suffisant pour avoir un fichier propre mais la structure en app et le fait que chaque saut de ligne dans le fichier original sois compté rend la chose complexe pour moi à nettoyer-->
    <xsl:template match="//body//text()">
        <xsl:variable name="sans_saut_ligne" select="replace(.,'\n+','')"/>
        <xsl:variable name="sans_espace" select='replace($sans_saut_ligne," +","^")'/>
        <xsl:value-of select='replace($sans_espace,"\^+"," ")'/>
    </xsl:template>
    
    
    <!-- J'ai préféré regrouper le CSS directement dans la feuille de transformation pour tout centraliser -->
    <xsl:template name="css">
        <xsl:result-document method="text" href="{concat($dossier_rendu,'/critique','.','css')}">
            body {
            font-family: Arial, sans-serif;
            font-size: 18px;
            line-height: 1.5;
            margin: 0;
            padding: 0;
            }
            .body{
            margin: 1%;
            background-color: rgba(240,240,240);
            padding: 3px;
            }
            header {
            background-color: #333;
            color: #fff;
            padding: 20px;
            }
            h1 {
            margin: 20px 0 10px;
            }
            a {
            color: #333;
            text-decoration: none;
            }
            a:hover {
            text-decoration: underline;
            }
            .lem{
            background-color: rgba(0,0,0,0.1);
            }
            .edition{
            text-align: justify;
            margin: 1%;
            }
            .lieux {
            font-style: italic;
            font-weight: bold;
            }
            .noms {
            font-weight: bold;
            }
            .index{
            font-weight: bold;
            }
            .text_name{
            font-weight: normal;
            }
            p {
            margin: 0 0 10px;
            }
            footer a {
            font-family: Arial, sans-serif;
            font-weight: bold;
            margin-right: 5%;
            margin-left: 5%;
            border-bottom: 1px solid #ccc;
            }
            footer a:hover {
            background-color: #ccc;
            color: #fff;
            }
            .orthographe{
            background-color: rgba(255,0,0,0.2);
            }
            .ponctuation{
            background-color: rgba(255,255,0,0.3);
            }
            .ordre{
            background-color: rgba(0,255,0,0.3);
            }
            .different{
            background-color: rgba(128,128,128,0.3);
            }
            .absence{
            background-color: rgba(255,192,203,0.3);
            }
            .sens{
            background-color: rgba(165,42,42,0.3);
            }
            .ajout{
            background-color: rgba(0,0,255,0.3);
            }
            .lacune{
            text-decoration : line-through;
            background-color: rgba(240,240,240);
            }
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
