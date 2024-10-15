abstract class IoDao<T> {
  Future<T?> read();
  Future<int> insert(T item);
  Future<int> update(T item);
  Future<int> delete();
}