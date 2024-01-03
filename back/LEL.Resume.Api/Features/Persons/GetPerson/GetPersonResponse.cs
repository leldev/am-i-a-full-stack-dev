namespace LEL.Resume.Api.Features.Persons.GetPerson;

public record GetPersonResponse
{
    public int Id { get; set; }

    public string Name { get; set; } = string.Empty;

    public string Nickname { get; set; } = string.Empty;

    public string Bio { get; set; } = string.Empty;

    public DateOnly Birthday { get; set; }

    public string Location { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string Degree { get; set; } = string.Empty;

    public string LinkedInUrl { get; set; } = string.Empty;

    public string GitHubUrl { get; set; } = string.Empty;

    public List<string> Languages { get; set; } = [];

    public List<string> Technologies { get; set; } = [];

    public List<string> Experiences { get; set; } = [];
}