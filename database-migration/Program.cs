using DbUp;
using DbUp.Engine;

if (args.Length != 2)
{
    Console.Error.WriteLine($"Expecting a single connection string & dabase name arguments but received {args.Length} argument(s).");
    Environment.Exit(-1);
    return;
}
var connectionString = args[0];
var databaseName = args[1];

ExecuteWithRetry(
    () => EnsureDatabase.For.PostgresqlDatabase(connectionString),
    retryCondition: ex => ex is Npgsql.NpgsqlException,
    onRetry: (ex, attempts, maxTimes, delay) => Console.WriteLine($"Database Server is not ready. Retry {attempts}/{maxTimes} in {delay}ms"),
    maxAttempts: 10,
    delay: 100
);

var dbupBuilder = DeployChanges.To
    .PostgresqlDatabase(connectionString)
    .LogToConsole()
    .LogScriptOutput()
    .WithExecutionTimeout(TimeSpan.FromSeconds(30))
    .WithScriptsFromFileSystem($"./Scripts/{databaseName}/Schema", new SqlScriptOptions { RunGroupOrder = 1 })
    .WithScriptsFromFileSystem($"./Scripts/{databaseName}/Static", new SqlScriptOptions { RunGroupOrder = 2 })
    .WithScriptsFromFileSystem($"./Scripts/{databaseName}/Sample", new SqlScriptOptions { RunGroupOrder = 3 });

// Console.WriteLine($"Include sample data: {Environment.GetEnvironmentVariable("INCLUDE_SAMPLE_DATA")}");

// if (Environment.GetEnvironmentVariable("INCLUDE_SAMPLE_DATA") != "Y")
// {
//     dbupBuilder.WithScriptsFromFileSystem($"./Scripts/{databaseName}/Sample", new SqlScriptOptions { RunGroupOrder = 3 });
// }

var result = dbupBuilder.Build().PerformUpgrade();

if (!result.Successful)
{
    Console.Error.WriteLine(result.Error);
    Environment.Exit(-1);
}

void ExecuteWithRetry(Action action, Func<Exception, bool> retryCondition, Action<Exception, int, int, int> onRetry, int maxAttempts, int delay)
{
    var attempts = 0;
    while (attempts <= maxAttempts)
    {
        attempts++;
        try
        {
            action();
        }
        catch (Exception ex) when (attempts < maxAttempts && retryCondition(ex))
        {
            onRetry(ex, attempts, maxAttempts, delay);
            Thread.Sleep(delay);
        }
    }
}

