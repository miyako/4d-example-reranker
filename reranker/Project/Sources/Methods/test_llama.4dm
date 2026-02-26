//%attributes = {}
var $client:=cs:C1710.AIKit.Reranker.new({baseURL: "http://127.0.0.1:8080/v1"})

var $query:=cs:C1710.AIKit.RerankerQuery.new({query: "What is deep learning?"; documents: [\
"Deep learning is a subset of machine learning based on artificial neural networks."; \
"Apples are red and sweet fruits that grow on trees."; \
"The theory of relativity was developed by Albert Einstein."; \
"Neural networks simulate the human brain to solve complex problems."\
]})

var $parameters:=cs:C1710.AIKit.RerankerParameters.new({model: "default"; top_n: 3})

var $result:=$client.rerank.create($query; $parameters)

SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($result.results; *))

/*

[
{
"index": 2,
"relevance_score": 0.61152515272163
},
{
"index": 1,
"relevance_score": 0.22917728905286
},
{
"index": 3,
"relevance_score": 0.19299100353743
}
]

*/