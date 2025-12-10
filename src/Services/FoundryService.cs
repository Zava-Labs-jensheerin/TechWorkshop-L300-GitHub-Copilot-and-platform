
using System.Text.Json;
using Azure;
using Azure.AI.Inference;
using Microsoft.Extensions.Configuration;

namespace ZavaStorefront.Services
{
    public class FoundryService : IFoundryService
    {
        private readonly ChatCompletionsClient _client;
        private readonly string _deploymentName;

        public FoundryService(IConfiguration config)
        {
            var endpoint = config["AzureAI:Endpoint"] ?? "";
            var key = config["AzureAI:ApiKey"] ?? "";
            var uri = new Uri(endpoint);
            var credential = new AzureKeyCredential(key);
            var clientOptions = new AzureAIInferenceClientOptions();
            _deploymentName = config["AzureAI:DeploymentName"] ?? "Phi-4";
            _client = new ChatCompletionsClient(uri, credential, clientOptions);
        }

        public async Task<string> SendPromptAsync(string prompt)
        {
            var options = new ChatCompletionsOptions()
            {
                Messages =
                {
                    new ChatRequestSystemMessage("You are a helpful assistant."),
                    new ChatRequestUserMessage(prompt)
                },
                MaxTokens = 2048,
                Temperature = 0.8f,
                NucleusSamplingFactor = 0.1f,
                PresencePenalty = 0.0f,
                FrequencyPenalty = 0.0f,
                Model = _deploymentName
            };

            Response<ChatCompletions> response = await _client.CompleteAsync(options);
            // Azure.AI.Inference likely uses Candidates for completions
            // Try using Content property directly
            var result = response.Value.Content;
            return result ?? string.Empty;
        }
    }
}
