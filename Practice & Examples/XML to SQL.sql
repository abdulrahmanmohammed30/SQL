declare @docs xml = 
'<Expressions>
  <Expression ExpressionId="1">
    <Text>mayor</Text>
    <IPA>   may·&amp;#8203;or  ˈmā-ər&amp;nbsp;                                                                                                                                ˈmer&amp;nbsp;                                                                                                        &amp;nbsp;especially before names&amp;nbsp; (ˌ)mer  </IPA>
    <LastUpdated>2024-09-26T14:28:50.9533333</LastUpdated>
    <Senses>
      <Sense Id="1">
        <Definition>: an official elected or appointed to act as chief executive or nominal head of a city, town, or borough </Definition>
        <ExpressionType Id="1">
          <Text>noun </Text>
        </ExpressionType>
        <DictionaryName>Oxford</DictionaryName>
      </Sense>
      <Sense Id="2">
        <Definition>: an official elected to act as head of a city or borough </Definition>
        <ExpressionType Id="1">
          <Text>noun </Text>
        </ExpressionType>
        <DictionaryName>Oxford</DictionaryName>
      </Sense>
      <Sense Id="3">
        <Definition>: an official elected or appointed to act as chief executive or nominal head of a city, town, or borough </Definition>
        <ExpressionType Id="1">
          <Text>noun </Text>
        </ExpressionType>
        <DictionaryName>Oxford</DictionaryName>
      </Sense>
    </Senses>
  </Expression>
</Expressions>'

-- 2)declare document handle 
Declare @hdocs INT 

--3)create memory tree 
Exec sp_xml_preparedocument @hdocs output, @docs

--4)process document 'read tree from memory' 
--OPENXML Creates Result set from XML Document 
-- Data currently is in XML format stored in Memory
-- OPENXML Reads XML and convert it to data or table 
SELECT * 
from OPENXML(@hdocs, '//Expression')  --levels XPATH Code 
WITH (
   ExpressionId int '@ExpressionId',
   ExpressionText varchar(255) 'Text',
   ExpressionIPA varchar(30) 'IPA',
   ExpressionLastUpdated datetime2 'LastUpdated'
)

--5)remove memory tree 
EXEC sp_xml_removedocument @hdocs