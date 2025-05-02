# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore
COPY ["hello-world-api.csproj", "./"]
RUN dotnet restore

# Copy the rest of the code and publish it
COPY . .
RUN dotnet publish -c Release -o /app/publish

# Final stage: use Lambda .NET 8 runtime image
FROM public.ecr.aws/lambda/dotnet:8

# Copy published app to Lambda image
COPY --from=build /app/publish ${LAMBDA_TASK_ROOT}

# Specify the Lambda handler (Namespace::ClassName::Method)
CMD [ "hello_world_api::hello_world_api.LambdaEntryPoint::FunctionHandlerAsync" ]
