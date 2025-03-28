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
 
    ai_project_conn_str = "southindia.api.azureml.ms;e654b0e0-2045-4ede-9910-26989f26232d;ebs-rg-hackathon;ebshack-2978"
    project_client = AIProjectClient.from_connection_string(
        credential=DefaultAzureCredential(),
        conn_str=ai_project_conn_str,   
    )

    prompt_template = PromptTemplate.from_prompty(file_path="converter.prompty")
    messages = prompt_template.create_messages(question=question, feedback=feedback)
 

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
            model="gpt-4o",
            name="ebs-hackathon",
            instructions=messages[0]['content'],
        )

        print(f"Created agent, ID: {agent.id}")

        # Create thread for communication
        thread = project_client.agents.create_thread()
        print(f"Created thread, ID: {thread.id}") 

        message = project_client.agents.create_message(
            thread_id=thread.id,
            role="user",
            content=question,
        )
        print(f"Created message, ID: {message.id}")


        # Create and process run
        run = project_client.agents.create_and_process_run(thread_id=thread.id, assistant_id=agent.id)
        print(f"Run finished with status: {run.last_error}")

        print("Agent created and now researching...")
        print('')

        project_client.agents.delete_agent(agent.id)
        print("Deleted agent")

        # Fetch and log all messages
        messages = project_client.agents.list_messages(thread_id=thread.id)
        #print(f"Messages: {messages}")

        response = messages.data[0]['content'][0]['text']['value']

        print(response)

    return "research"
 
@trace
def research(question: str, feedback: str = "No feedback"):
    research = execute_dbresearch(question=question, feedback=feedback)
    return "Success"

research(""""  Convert the python legacy code to java code. Just give the code as the output. Write nothing except the executable code. Translate Python code using legacy libraries (e.g., 
requests, pandas, flask) to Java equivalents (e.g., HttpClient, Spring Boot, JPA). Ensure the converted Java code follows cloud principles 
(containerization, API-first, scalability). Convert Python Flask-based services into Spring Boot 
microservices. Generate unit tests in Java to match Python test behavior if python tests exists. Write nothing except the executable code.

import numpy as np
import matplotlib.pyplot as plt

# Function to compute the Fourier Transform of a signal
def compute_fourier_transform(signal):
    return np.fft.fft(signal)

# Generate a sample signal: a sum of two sine waves
t = np.linspace(0, 1, 500)
signal = np.sin(2 * np.pi * 50 * t) + np.sin(2 * np.pi * 120 * t)

# Compute the Fourier Transform of the signal
fourier_transform = compute_fourier_transform(signal)

# Compute the frequencies corresponding to the Fourier Transform
frequencies = np.fft.fftfreq(len(fourier_transform))

# Plot the original signal
plt.subplot(2, 1, 1)
plt.plot(t, signal)
plt.title('Original Signal')

# Plot the magnitude of the Fourier Transform
plt.subplot(2, 1, 2)
plt.plot(frequencies, np.abs(fourier_transform))
plt.title('Fourier Transform')
plt.xlabel('Frequency')
plt.ylabel('Magnitude')

plt.tight_layout()
plt.show()
        """)