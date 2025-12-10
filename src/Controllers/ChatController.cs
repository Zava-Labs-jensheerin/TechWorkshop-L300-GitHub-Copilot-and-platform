using Microsoft.AspNetCore.Mvc;
using ZavaStorefront.Services;

namespace ZavaStorefront.Controllers
{
    public class ChatController : Controller
    {
        private readonly IFoundryService _foundryService;

        public ChatController(IFoundryService foundryService)
        {
            _foundryService = foundryService;
        }

        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        [Route("/Chat/Send")]
        public async Task<IActionResult> Send([FromForm] string prompt)
        {
            if (string.IsNullOrWhiteSpace(prompt))
                return Json(new { result = "" });

            var result = await _foundryService.SendPromptAsync(prompt);
            return Json(new { result });
        }
    }
}
