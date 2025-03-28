import os
import sys
import json
from enum import Enum
from pydantic import BaseModel, TypeAdapter
 
from dotenv import load_dotenv
import prompty
import prompty.azure
from prompty.azure.processor import ToolCall
from prompty.tracer import trace
from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential
from azure.ai.projects.models import AzureAISearchTool, ConnectionType
from azure.ai.inference.prompts import PromptTemplate
from pathlib import Path
 
load_dotenv()


# Create an Azure AI Client from a connection string, copied from your Azure AI Foundry project.
# At the moment, it should be in the format "<HostName>;<AzureSubscriptionId>;<ResourceGroup>;<HubName>"
# Customer needs to login to Azure subscription via Azure CLI and set the environment variables
 
@trace
def execute_dbresearch(question: str, feedback: str = "No feedback"):
 
    ai_project_conn_str = "southindia"+".api.azureml.ms;"+"e654b0e0-2045-4ede-9910-26989f26232d"+";"+"ebs-rg-hackathon"+";"+"ebs-hackathon"
    project_client = AIProjectClient.from_connection_string(
        credential=DefaultAzureCredential(),
        conn_str=ai_project_conn_str,
    )

    conn_list = project_client.connections.list()
    conn_id = ""
    for conn in conn_list:
        if conn.connection_type == ConnectionType:
            conn_id = conn.id
            break

    print (conn_id)
    # Initialize azure ai search tool and add the connection id

 
    with project_client:
        agent = project_client.agents.create_agent(
            model="gpt-4",
            name="ebs-hackathon",
            instructions="You are an expert in python to Java code conversion",
            headers={"x-ms-enable-preview": "true"},
        )

        print(f"Created agent, ID: {agent.id}")

        # Create thread for communication
        thread = project_client.agents.create_thread()
        print(f"Created thread, ID: {thread.id}") 

    return "research"
 
@trace
def research(question: str, feedback: str = "No feedback"):
    research = execute_dbresearch(question=question, feedback=feedback)
    print(research)
    return research

research("abc")