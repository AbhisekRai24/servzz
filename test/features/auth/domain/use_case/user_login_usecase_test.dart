import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:servzz/app/shared_pref/token_shared_prefs.dart';
import 'package:servzz/core/error/failure.dart';
import 'package:servzz/features/auth/domain/repository/user_repository.dart';
import 'package:servzz/features/auth/domain/use_case/user_login_usecase.dart';

// Mocks for required class files
class MockUserRepository extends Mock implements IUserRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

void main() {
  late MockUserRepository mockUserRepository;
  late MockTokenSharedPrefs mockTokenSharedPrefs;
  late UserLoginUsecase usecase;

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tToken = 'abc123token';
  const tParams = LoginParams(email: tEmail, password: tPassword);

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockTokenSharedPrefs = MockTokenSharedPrefs();
    usecase = UserLoginUsecase(
      userRepository: mockUserRepository,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );

    registerFallbackValue(const LoginParams(email: '', password: ''));
  });

  group('Two UserLoginUsecase Tests ', () {
    test('Save token when login is successful', () async {
      // arrange
      when(
        () => mockUserRepository.loginUser(any(), any()),
      ).thenAnswer((_) async => const Right(tToken));

      when(
        () => mockTokenSharedPrefs.saveToken(any()),
      ).thenAnswer((_) async => const Right(null));

      // act
      final result = await usecase(tParams);

      // assert
      expect(result, const Right(tToken));
      verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
      verify(() => mockTokenSharedPrefs.saveToken(tToken)).called(1);
      verifyNoMoreInteractions(mockUserRepository);
      verifyNoMoreInteractions(mockTokenSharedPrefs);
    });

    test(
      'Should return Failure when repository fails and should not save token',
      () async {
        // arrange
        const failure = RemoteDatabaseFailure(message: 'Login failed');
        when(
          () => mockUserRepository.loginUser(any(), any()),
        ).thenAnswer((_) async => const Left(failure));

        // act
        final result = await usecase(tParams);

        // assert
        expect(result, const Left(failure));
        verify(() => mockUserRepository.loginUser(tEmail, tPassword)).called(1);
        verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
        verifyNoMoreInteractions(mockUserRepository);
        verifyNoMoreInteractions(mockTokenSharedPrefs);
      },
    );
  });
}
