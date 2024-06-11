# Google GKE LLM Model Comparison & Evaluation Dashboard

## What is RAG?
[RAG](https://cloud.google.com/blog/products/ai-machine-learning/rag-with-databases-on-google-cloud) is a popular approach for boosting the accuracy of LLM responses, particularly for domain specific or private data sets.

RAG uses a semantically searchable knowledge base (like vector search) to retrieve relevant snippets for a given prompt to provide additional context to the LLM. Augmenting the knowledge base with additional data is typically cheaper than fine tuning and is more scalable when incorporating current events and other rapidly changing data spaces.

## What is langchain?
LangChain is a framework designed to simplify the creation of applications using large language models (LLMs). As a language model integration framework, LangChain's use-cases largely overlap with those of language models in general, including document analysis and summarization, chatbots, and code analysis

## Introduction

The Google GKE LLM Model Comparison Tool helps data analysts and developers quickly assess open-source pre-trained models (Google, OpenAPI, Hugging Face) by ingesting their own datasets (currently, only PDFs are supported).

There are two main steps:

1. **Prepare the Data**:
   - **Upload PDF Documents**: Upload your selected PDF documents first. Once PDFs are uploaded into the dashboard, they are saved into a container which can be viewed under the File upload Widget.
   - **Create Local Vector Embedding Databases**: Select the desired embeddings model from the right hand view and run the indexing to create local vector indexes. This can be repeated as necessary, which will override the index.
   
2. **Run Inferences**:
   - Select Local Vector Index.
   - Select the LLM Pre-trained Model.
   - Enter Your Question.
   - Compare Results in the 2x2 Evaluation section.

# Prerequisites

Below tools are required to be install on your computer.

* [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
* [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* [Gcloud](https://cloud.google.com/sdk/docs/install)

# Installation

## 1. Cloning the Repository

```bash
git clone https://github.com/GoogleCloudPlatform/ai-on-gke.git
```

## 2. Enter into rag-llm folder

```bash
cd ai-on-gke/application/rag-langchain
```
## 3. Create an Autopilot GKE Cluster

Create an [Autopilot GKE Cluster]((https://cloud.google.com/kubernetes-engine/docs/how-to/creating-an-autopilot-cluster)) by following [these](https://cloud.google.com/kubernetes-engine/docs/how-to/creating-an-autopilot-cluster) steps. If you already have an autopilot cluster skip this step.

## 4. Logging in to gcloud via CLI

```
gcloud auth login
```

## 5. Modify Placeholders

Open **variables.tf** and update the placeholder values. Update **GCP Project Id**, **Region** and **GKE Cluster Name**

```
variable "project_id" {
    default = "YOUR_PROJECT_ID"
 }
variable "region" {
  default = "YOUR_REGION" /* example: "us-central1" */
}
variable "cluster-name" {
  type        = string
  default     = "YOUR_GKE_CLUSTER"
}
```

## 5. Get Application keys

* [OpenAI keys](https://help.openai.com/en/articles/4936850-where-do-i-find-my-openai-api-key)
* [GoogleAI Keys](https://aistudio.google.com/app/apikey)
* [HuggingFaceAI Keys](https://aistudio.google.com/app/apikey)


## 6. Start the Installation

```
$ terraform init

$ terraform validate

$ terraform apply
```
## 6. Enter your LLM Keys

Terraform apply will prompt you to enter the keys as shown below:

```
$ terraform apply

var.secret_google_api_value
  Enter a value: 

var.secret_hf_api_value
  Enter a value: 

var.secret_openapi_api_value
  Enter a value: 
```

Currently dashboard supports 4 Vector Index Embeddings Models (from 3 vendords - OpenAI, Google and Huggingface) namely,

* OpenAIEmbeddings
  ```
  docEmbedding = OpenAIEmbeddings(api_key=os.getenv("OPENAI_API_KEY"))
  ``` 
* GoogleGenerativeAIEmbeddings
  ```
  docEmbedding = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
  ```
* GPT4AllEmbeddings
  ```
  docEmbedding = GPT4AllEmbeddings(
                    model_name="all-MiniLM-L6-v2.gguf2.f16.gguf",
                    gpt4all_kwargs={'allow_download': 'True'}
                 )
  ```
* HuggingFaceEmbeddings
  ```
  docEmbedding = HuggingFaceEmbeddings(
                      model_name="sentence-transformers/all-mpnet-base-v2",
                      model_kwargs={'device': 'cpu'},
                      encode_kwargs={'normalize_embeddings': False}
                    )
  ```

Applications creates a local vector indexes in the container using Chroma

```
from langchain_community.vectorstores import Chroma
```

*Note - Adding more vector embeddings models is easy, just modify to the file <TBD>*

## 7. Validate the GKE Workload
<TBD>

## 8. Validate the GKE Service
<TBD>

## 9. Load the application
<TBD>

## 10. Upload PDF Files & Create local Vector Index DB
<TBD>

## 11. Evaluate and compare
<TBD>