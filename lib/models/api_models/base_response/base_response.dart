class BaseResponse<T> {
  final T? snapshot;
  final String? error;

  BaseResponse(this.snapshot, this.error);
}
