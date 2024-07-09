using Godot;
using System;
using System.Collections.Generic;
using OpenAI;
using OpenAI.Managers;
using OpenAI.ObjectModels;
using OpenAI.ObjectModels.RequestModels;
using Environment = Godot.Environment;

public partial class OpenAIService : Control
{
    public async override void _Ready()
    {
        var openAiService = new OpenAI.Managers.OpenAIService(new OpenAiOptions()
            {
                ApiKey = "sk-proj-jIsGb8cBqZuDiyQMiCm7T3BlbkFJm3qRNmYE9Nk5Rfy53zAC"
            }
        );
        
        var result = await openAiService.ChatCompletion.CreateCompletion(new ChatCompletionCreateRequest
        {
            Messages = new List<ChatMessage>
            {
                ChatMessage.FromSystem("You are a helpful assistant."),
                ChatMessage.FromUser("Who won the world series in 2020?"),
                ChatMessage.FromAssistant("The Los Angeles Dodgers won the World Series in 2020."),
                ChatMessage.FromUser("Where was it played?")
            },
            Model = Models.Gpt_3_5_Turbo
        });

        if (result.Successful)
        {
            GD.Print(result);
        }
        else
        {
            GD.Print(result.Error.Code);
        }
    }
}
