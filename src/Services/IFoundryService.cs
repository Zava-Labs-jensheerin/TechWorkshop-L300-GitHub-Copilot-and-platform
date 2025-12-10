namespace ZavaStorefront.Services
{
    public interface IFoundryService
    {
        Task<string> SendPromptAsync(string prompt);
    }
}
