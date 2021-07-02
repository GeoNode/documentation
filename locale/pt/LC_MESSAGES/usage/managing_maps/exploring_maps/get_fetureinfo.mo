��    '      T  5   �      `     a  	   j  	   t  	   ~  	   �     �     �     �     �     �     �     �     �  -   �  h     [   q  M   �  l     0   �  W   �  u     �   �  l   !  6   �  2   �  ;   �  �   4  �   	  �   �	  �   �
  g   �      J     �   e  �   �  V   �  -     -   6  J  d     �  	   �  	   �  	   �  	   �     �     �     �     �                      2   (  ~   [  ]   �  R   8  z   �  4     ]   ;  t   �  �     n   �  B     <   _  B   �  �   �  �   �  �   �  �   �  s   �  4  �  L   *  �   w  �     h   �  '   D  8   l               #      $                                     "          !            	             %                          '              
       &                                     *Fig. 1* *Fig. 10* *Fig. 11* *Fig. 12* *Fig. 13* *Fig. 2* *Fig. 3* *Fig. 4* *Fig. 5* *Fig. 6* *Fig. 7* *Fig. 8* *Fig. 9* Advanced Template: Use A Custom HTML Template As an instance, by using the example above, we can customize a bit the Layer Metadata as shown in Fig. 2 By changing the :guilabel:`Display Type` of an attribute from this panel as shown in Fig. 4 By selecting the option :guilabel:`Use a custom template?` as shown in Fig. 9 Currently, GeoNode allows a very simple mechanism to customize the “GetFeatureInfo Template” of a Layer. Customizing The Layers' GetFeatureInfo Templates For more information about the Javascript tool, please refer to https://www.tiny.cloud/ GeoNode will create automatically the HTML media type when rendering by using the **value** of the selected property. It is possible, through the Layer Metadata Editor Wizard, to assign a name and a label to the attributes we want to display on the GetFeatureInfo output. Notice that the attributes without a label and name, in case others are present, won’t be rendered at all. Optional: Customizing the HTML WYSIWYG Editor Menu Bar Selecting :guilabel:`image` as media-type (Fig. 6) Simple Template: Assigning A Media-Type To Attribute Values So, as an example, if, in the figure above, the attribute ``NAME`` contains values representing some ``links`` to other resources, GeoNode will create those links automatically for you when clicking over a geometry. The :guilabel:`Menu Bar` and :guilabel:`Tool Bar` of the HTML Editor, can be easily customized by overriding the ``TINYMCE_DEFAULT_CONFIG`` variable on :guilabel:`settings.py` (see :ref:`tinyMCE Default Config Settings`) The easiest way to render a different media-type (:guilabel:`image`, :guilabel:`audio`, :guilabel:`video` or :guilabel:`iframe`) to a property value, is to change it from the :guilabel:`Metadata Editor Wizard` attributes panel. The example below shows how it is possible to create a nice HTML output with an :guilabel:`image` taking the ``src`` from the attribute :guilabel:`NAME` values, through the use of the keyword ``${properties.NAME}`` The outcome is a rendered HTML snippet with the real values replacing the placeholders of the Template. The way how such information is presented to the user is defined by what we call “GetFeatureInfo Template”. The latter is basically an HTML snippet containing some placeholders and special inline codes that instruct GeoServer on how to generate the raw data output. The “GetFeatureInfo” output will change accordingly as shown in Fig. 3 There are many plugins and options allowing you to easily customize the editor and also provides some predefined *templates* to speed up the editing. When “clicking” over a feature of a Layer into a GeoNode Map, an info window popups showing a formatted representation of the raw data identified by the coordinates (see Fig. 1) You will be able to provide your own custom HTML Template for the Feature Info output. and editing the contents accordingly (Fig. 7) you will get a nice effect as shown in Fig. 8 Project-Id-Version: GeoNode 3.2.0
Report-Msgid-Bugs-To: 
PO-Revision-Date: 2021-07-02 20:34+0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Generated-By: Babel 2.9.0
Plural-Forms: nplurals=2; plural=(n != 1);
Last-Translator: 
Language-Team: 
Language: pt_PT
X-Generator: Poedit 3.0
 *Fig. 1* *Fig. 10* *Fig. 11* *Fig. 12* *Fig. 13* *Fig. 2* *Fig. 3* *Fig. 4* *Fig. 5* *Fig. 6* *Fig. 7* *Fig. 8* *Fig. 9* Modelo Avançado: Use um Modelo HTML Personalizado Como uma instância, usando o exemplo acima, podemos personalizar um pouco os Metadados da Camada, conforme mostrado na Fig. 2 Alterando o :guilabel:`Display Type` de um atributo deste painel, conforme mostrado na Fig. 4 Seleccionando a opção :guilabel:`Use a custom template?` Como mostrado na Fig. 9 Actualmente, o GeoNode permite um mecanismo muito simples para personalizar o “Template GetFeatureInfo” de uma camada. Personalizando os Modelos GetFeatureInfo das Camadas Para obter mais informações sobre a ferramenta Javascript, consulte https://www.tiny.cloud/ O GeoNode criará automaticamente o tipo de mídia HTML ao renderizar usando o **valor** da propriedade selecionada. É possível, por meio do Assistente Editor de Metadados de Camada, atribuir um nome e um rótulo aos atributos que desejamos exibir na saída GetFeatureInfo. Observe que os atributos sem um rótulo e nome, no caso de outros estarem presentes, não serão renderizados. Opcional: Personalização da Barra de Menu do Editor HTML WYSIWYG Seleccionando :guilabel:`image` como tipo-de-mídia (Fig. 6) Modelo Simples: atribuindo um Tipo-de-Mídia a Valores de Atributo Assim, a título de exemplo, se, na figura acima, o atributo ``NOME`` contém valores que representam alguns ``links`` para outros recursos, o GeoNode irá criar esses links automaticamente para você ao clicar sobre uma geometria. O :guilabel:`Barra de Menu` e :guilabel:`Barra de Ferramentas` do Editor de HTML, pode ser facilmente personalizado substituindo a variável ``TINYMCE_DEFAULT_CONFIG`` em :guilabel:`settings.py` (veja :ref:`tinyMCE Default Config Settings`) A maneira mais fácil de renderizar um tipo-de-mídia diferente (:guilabel:`imagem`, :guilabel:`audio`, :guilabel:`video` ou :guilabel:`iframe`) para um valor de propriedade, é alterá-lo do painel de atributos :guilabel:`Metadata Editor Wizard`. O exemplo abaixo mostra como é possível criar uma boa saída HTML com uma :guilabel:`image` tomando o``src`` dos valores do atributo :guilabel:`NAME`, através do uso da palavra-chave ``${properties.NAME}`` O resultado é um fragmento de HTML renderizado com os valores reais substituindo os espaços reservados do Modelo. A forma como essas informações são apresentadas ao usuário é definida pelo que chamamos de “Template GetFeatureInfo”. O último é basicamente um trecho de HTML contendo alguns marcadores de posição e códigos embutidos especiais que instruem o GeoServer sobre como gerar a saída de dados brutos. A saída “GetFeatureInfo” mudará de acordo, conforme mostrado na Fig. 3 Existem muitos plug-ins e opções que permitem personalizar facilmente o editor e também fornece alguns *modelos* predefinidos para acelerar a edição. Ao “clicar” sobre um recurso de uma camada em um mapa GeoNode, uma janela pop-up de informações mostra uma representação formatada dos dados brutos identificados pelas coordenadas (ver Fig. 1) Você poderá fornecer seu próprio modelo HTML personalizado para a saída de informações do recurso. e editar o conteúdo de acordo (Fig. 7) você obterá um bom efeito, conforme mostrado na Fig. 8 