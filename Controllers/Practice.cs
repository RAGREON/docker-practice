using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class PracticeController : ControllerBase
{
  public PracticeController()
  {
  }

  [HttpGet]
  public IActionResult GetTime()
  {
    var currentTime = DateTime.UtcNow;

    return Ok(currentTime);
  }

  public IActionResult GetCores()
  {
    return Ok("12");
  }
}