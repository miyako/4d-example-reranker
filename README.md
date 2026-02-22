# 4d-example-reranker

Sample project to test AI Kit rerank support

[`XLM-RoBERTa`](https://huggingface.co/docs/transformers/model_doc/xlm-roberta) seems to have the widest support. `llama.cpp` seems to default to `XLM-RoBERTa` making [`BERT`](https://huggingface.co/docs/transformers/model_doc/bert) reranking incorrect. `int8` quantisation is normally preferred on a CPU but for BERT models which are small by design, it makes sense to use `float16`.

### Compatibility

Some reranker models are fine tuned causal LLMs; you prompt the AI to rate a set of passages based on thier relevance to a query. The prompt does not follow the user/assistant configuration, which means you must send it to the `/completion` endpoint, not the `chat/completion` endpoint. In any case, these models are no compatible with the `/rerank` endpoint.

```json
{
  "prompt": "Predict if the following passage is relevant to the query: What is the capital of France?\nPassage: Paris is the capital and most populous city of France.\nOutput:",
  "n_predict": 1,
  "temperature": 0.0,
  "top_k": 1,
  "top_p": 1.0,
  "stream": false
}
```

- [`BAAI/bge-reranker-v2-gemma`](https://huggingface.co/BAAI/bge-reranker-v2-gemma)

---

Some reranker models are repurposed causal LLMs; they process token IDs and output logits like an encoder, but the internal architechture is based on a decoder model. These models have a large context window compared to a classic encoder and tend to capture subtle nuances, but the size is large and the inference is computationally expensive.

- [`Qwen/Qwen3-Reranker-0.6B`](https://github.com/miyako/4d-example-reranker/blob/main/README.md#qwenqwen3-reranker-06b)

---

Bigger does not necessarily mean better. The additional layers and parameters of a large model probably creates weights that exceeds the dynamic range of `f16` or `bf16`. Quantised "large" models often generate invalid result. It is normally better to use the "base" model.

- [mixedbread-ai/mxbai-rerank-large-v1](https://github.com/miyako/4d-example-reranker/edit/main/README.md#mixedbread-aimxbai-rerank-large-v1)

---

`llama.cpp` supports both `XLM-RoBERTa` and LLM (qwen) rerankers but not BERT rerankers.

- [amberoad/bert-multilingual-passage-reranking-msmarco](https://github.com/miyako/4d-example-reranker#amberoadbert-multilingual-passage-reranking-msmarco)
- [cross-encoder/ms-marco-MiniLM-L6-v2](https://github.com/miyako/4d-example-reranker?tab=readme-ov-file#cross-encoderms-marco-minilm-l6-v2)

---

## Example

```4d
var $client:=cs.AIKit.Reranker.new({baseURL: "http://127.0.0.1:8080/v1"})

var $query:=cs.AIKit.RerankerQuery.new({query: "What is deep learning?"; documents: [\
"Deep learning is a subset of machine learning based on artificial neural networks."; \
"Apples are red and sweet fruits that grow on trees."; \
"The theory of relativity was developed by Albert Einstein."; \
"Neural networks simulate the human brain to solve complex problems."\
]})

var $parameters:=cs.AIKit.RerankerParameters.new({model: "default"; top_n: 3})

var $result:=$client.rerank.create($query; $parameters)
```

### 🥇 [BAAI/bge-reranker-v2-m3](https://huggingface.co/BAAI/bge-reranker-v2-m3)

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.99975650378508`|`0.99979907274246`|`0.99974030256271`|
|`3`|`0.0040334316733283`|`0.0034260561224073`|`0.0037298486568034`|
|`2`|`0.00001605949705307`|`0.00001626304583624`|`0.00001607972626516`|

---

### 🥈 [BAAI/bge-reranker-large](https://huggingface.co/BAAI/bge-reranker-large)

||GGUF Q8_0|ONNX Int8|CTranslate Int8| 
|-|-|-|-
|`0`|`0.99963819980621`|`0.99949955940247`|`0.99963819980621`|
|`3`|`0.069412730634212`|`0.05670153722167`|`0.069412730634212`|
|`2`|`0.00007634641951881`|`0.00007670062768739`|`0.00007634641951881`|

---

### 🥉 [cross-encoder/mmarco-mMiniLMv2-L12-H384-v1](https://huggingface.co/cross-encoder/mmarco-mMiniLMv2-L12-H384-v1)

||GGUF Q8_0|ONNX Int8|CTranslate Int8| 
|-|-|-|-
|`0`|`0.99997075413285`|`0.99991273880005`|`0.99996781349182`|
|`3`|`0.021881894500755`|`0.020335288718343`|`0.02367801591754`|
|`2`|`0.0037152149705926`|`0.0090650934726`|`0.0035643121227622`|

---

###  [BAAI/bge-reranker-base](https://huggingface.co/BAAI/bge-reranker-base)

> This model correctly identifies the most relevant document and its general significance but fails to weigh minor details.

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.99974032333812`|`0.99875009059906`|`0.99971753358841`|
|`3`|`0.00003758999629534`⤴|`0.00003786411252804`⤴|`0.00003765087967622`⤴|
|`2`|`0.00035163012593452`⤵|`0.00016138107457664`⤵|`0.00032641555299051`⤵|

---

### [Qwen/Qwen3-Reranker-0.6B](https://huggingface.co/Qwen/Qwen3-Reranker-0.6B)

> This model is a repurposed decoder. It performs better on GGUF "K" quants. Also the pooling on ONNX might be incorrect.

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.99849343299866`|`0.3774676322937`||
|`3`|`0.17696142196655`|`0.19882951676846`|
|`2`|`0.00014215805276763`|`0.18937009572983`||

---

### [amberoad/bert-multilingual-passage-reranking-msmarco](https://huggingface.co/amberoad/bert-multilingual-passage-reranking-msmarco)

> This model is BERT. No GGUF version available.

||GGUF Q8_0|ONNX F16|ONNX Int8|CTranslate Int8
|-|-|-|-|-
|`0`||`0.99972993135452`|`0.99938893318176`|`0.9980161190033`|
|`3`||`0.00001711601180432`|`0.00001833355418057`|`0.0012083178153262`|
|`2`||`0.00001573694680701`|`0.00014862575335428`|`0.0004223593568895`|

---

### [cross-encoder/ms-marco-MiniLM-L6-v2](https://huggingface.co/cross-encoder/ms-marco-MiniLM-L6-v2)

> This model is BERT, not XLM-RoBERTa. The flat results suggest a `llama.cpp` bug in BERT reranking (not using token type IDs).

||GGUF F16|GGUF Q8_0|ONNX F16|ONNX Int8|CTranslate Int8
|-|-|-|-|-|-
|`0`|`0.4982936187771`|`0.4982936187771`|`0.99997842311859`|`0.99997627735138`|`1`|
|`3`|`0.48758885823757`|`0.48758885823757`|`0.00002105345265591`|`0.00002080343438138`|`0.0000000004588505964076`|
|`2`|`0.48588368773412`|`0.48588368773412`|`0.00001613207132323`|||

---

### [jinaai/jina-reranker-v1-turbo-en](https://huggingface.co/jinaai/jina-reranker-v1-turbo-en)

> This model seems to have a non standard BERT implementation (`[batch, 1]`).

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.47711632548651`|`0.26465171575546`⤵||
|`3`|`0.47559809684731`⤴|`0.27939757704735`⤵||
|`2`|`0.47688768439384`⤵||

---

### [jinaai/jina-reranker-v2-base-multilingual](https://huggingface.co/jinaai/jina-reranker-v2-base-multilingual)

> This model seems to be a custom variation of XLM-RoBERTa. No ONNX or CTranslate2 version available.

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.91580612478166`|||
|`3`|`0.19414707725`|||
|`2`||||

---

### [ibm-granite/granite-embedding-reranker-english-r2](https://huggingface.co/ibm-granite/granite-embedding-reranker-english-r2)

>  This model is ModernBERT. Export to GGUF is not supported as of February 2026.

||GGUF Q8_0|ONNX F16|ONNX Int8|CTranslate Int8
|-|-|-|-|-
|`0`||`0.91985809803009`|`0.79878783226013`||
|`3`||`0.078764326870441`|`0.67189735174179`||
|`2`|||`0.47672122716904`||

---

### [mixedbread-ai/mxbai-rerank-xsmall-v1](https://huggingface.co/mixedbread-ai/mxbai-rerank-xsmall-v1)

> This model is DeBERTa-v2. Export to GGUF is not supported as of February 2026.

||GGUF Q8_0|ONNX F16|ONNX Int8|CTranslate Int8
|-|-|-|-|-
|`0`||`0.91985809803009`|`0.76543623209`||
|`3`||`0.078764326870441`|`0.11033684015274`⤵||
|`2`|||||

---

### [mixedbread-ai/mxbai-rerank-base-v1](https://huggingface.co/mixedbread-ai/mxbai-rerank-base-v1)

> This model is DeBERTa-v2. Export to GGUF is not supported as of February 2026.

||GGUF Q8_0|ONNX F16|ONNX Int8|CTranslate Int8
|-|-|-|-|-
|`0`||`0.94747817516327`|`0.23237489163876`||
|`3`||`0.25853633880615`|`0.19631579518318`||
|`2`||`0.0044187577441335`|||

---

### [mixedbread-ai/mxbai-rerank-large-v1](https://huggingface.co/mixedbread-ai/mxbai-rerank-large-v1)

> [!WARNING]
> The model might have collapsed under its own weight. Notice the superior results in base and xsmall.

> This model is DeBERTa-v2. Export to GGUF is not supported as of February 2026.

||GGUF Q8_0|ONNX F16|ONNX Int8|CTranslate Int8
|-|-|-|-|-
|`0`||`0.050157018005848`⤵||
|`3`||||
|`2`||`0.071954950690269`⤴||

---

### [jinaai/jina-reranker-v3](https://huggingface.co/jinaai/jina-reranker-v3)

> [!WARNING]
> The pooling in llama.cpp is completely off but the model works well on [Jina AI](https://jina.ai/reranker/).

||GGUF Q8_0|ONNX Int8|CTranslate Int8
|-|-|-|-
|`0`|`0.75106662511826`|||
|`3`||||
|`2`|`0.24428156018257`|||
