import 'package:get_it/get_it.dart';
import '../features/chat/data/datasources/chat_remote_data_source.dart';
import '../features/chat/data/repositories/chat_repository_impl.dart';
import '../features/chat/domain/repositories/chat_repository.dart';
import '../features/chat/presentation/presenter/chat_presenter.dart';

final sl = GetIt.instance;

void init() {
  // 1. Presenter
  sl.registerFactory(() => ChatPresenterImpl(repository: sl()));

  // 2. Repository
  sl.registerLazySingleton<ChatRepository>(
        () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  // 3. Data Source
  sl.registerLazySingleton<ChatRemoteDataSource>(
        () => ChatRemoteDataSourceImpl(),
  );
}