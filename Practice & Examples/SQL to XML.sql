
select	Expressions.Id "@ExpressionId",
        Expressions.Text "Text",
		Expressions.IPA "IPA",
		Expressions.LastUpdated "LastUpdated",
		Senses.Id "Senses/@Id",
		Senses.Definition "Senses/Definition",
		ExpressionTypes.Id "Senses/ExpressionType/@Id",
		ExpressionTypes.Text "Senses/ExpressionType/Text",
        Dictionaries.DictionaryName "Senses/DictionaryName",
		Examples.Id  "Senses/Examples/Example/@Id",
		Examples.Text  "Senses/Examples/Example/Text"
from senses
join Expressions
on Senses.ExpressionId = Expressions.Id
join ExpressionTypes 
on Senses.ExpressionTypeId = ExpressionTypes.Id
join Dictionaries
on Senses.DictionaryId =Dictionaries.Id
join Examples 
on Examples.SenseId = Senses.Id
for xml path ('Expression'), root('Expressions')


SELECT
    Expressions.Id AS "@ExpressionId",
    Expressions.Text AS "Text",
    Expressions.IPA AS "IPA",
    Expressions.LastUpdated AS "LastUpdated",
    (
        SELECT
            Senses.Id AS "@Id",
            Senses.Definition AS "Definition",
            ExpressionTypes.Id AS "ExpressionType/@Id",
            ExpressionTypes.Text AS "ExpressionType/Text",
            Dictionaries.DictionaryName AS "DictionaryName",
            (
                SELECT
                    Examples.Id AS "Example/@Id",
                    Examples.Text AS "Example/Text"
                FROM Examples
                WHERE Examples.SenseId = Senses.Id
                FOR XML PATH('Examples'), TYPE
            )
        FROM Senses
        JOIN ExpressionTypes
            ON Senses.ExpressionTypeId = ExpressionTypes.Id
        JOIN Dictionaries
            ON Senses.DictionaryId = Dictionaries.Id
        WHERE Senses.ExpressionId = Expressions.Id
        FOR XML PATH('Sense'), TYPE
    ) AS "Senses"
FROM Expressions
FOR XML PATH('Expression'), ROOT('Expressions');
