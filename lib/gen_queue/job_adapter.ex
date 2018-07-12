defmodule GenQueue.JobAdapter do
  @moduledoc """
  A behaviour module for implementing job queue adapters.
  """

  @doc """
  Pushes a job to a queue
  """
  @callback handle_job(gen_queue :: GenQueue.t(), job :: GenQueue.Job.t()) ::
              {:ok, GenQueue.Job.t()} | {:error, any}

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour GenQueue.JobAdapter

      use GenQueue.Adapter

      @doc """
      Callback implementation for `GenQueue.Adapter.push/2`
      """
      def handle_push(gen_queue, item, opts) do
        handle_job(gen_queue, GenQueue.Job.new(item, opts))
      end

      @doc false
      def handle_job(_gen_queue, _job) do
        {:error, :not_implemented}
      end

      defoverridable GenQueue.JobAdapter
    end
  end
end
