defmodule AveloData.S3Client do
  defmodule S3Request do
    use TypedStruct

    typedstruct do
      field :key, String.t(), enforce: true
      field :body, binary()
    end
  end

  def put_object(%S3Request{body: body} = request) when not is_nil(body) do
    %{
      base_url: base_url,
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      bucket: bucket
    } = AveloDataConfig.object_storage()

    Req.put(
      "#{base_url}/#{bucket}/#{request.key}",
      aws_sigv4: %{
        access_key_id: access_key_id,
        secret_access_key: secret_access_key,
        service: "s3"
      },
      body: body
    )
    |> case do
      {:ok, _} -> :ok
      error -> error
    end
  end

  def get_object(%S3Request{} = request) do
    %{
      base_url: base_url,
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      bucket: bucket
    } = AveloDataConfig.object_storage()

    Req.get("#{base_url}/#{bucket}/#{request.key}",
      aws_sigv4: %{
        access_key_id: access_key_id,
        secret_access_key: secret_access_key,
        service: "s3"
      }
    )
  end
end
