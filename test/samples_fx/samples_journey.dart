import '../samples.dart';

// ignore_for_file: unnecessary_raw_strings

const sampleFxJourney = TestSampleData(
  source: r'''
library journey;

import 'dart:io';

import 'dart:io2';

import 'package:flutter/material.dart';


import 'package:fx/src/common/common.dart';
import 'package:fx/src/journeys/data_sources/journeys_remote_data_source.dart';
import 'package:fx/src/journeys/data_sources/teg/journey_api.dart';
import 'package:fx/src/journeys/data_sources/teg/teg_journeys_remote_data_source.dart';
import 'package:fx/src/journeys/exceptions/journey_overlapped_exception.dart';
import 'package:fx/src/journeys/repositories/journeys_repository.dart';
import 'package:fx/src/journeys/use_cases/create_going_home_journey_use_case.dart';
import 'package:fx/src/journeys/use_cases/create_journey_use_case.dart';
import 'package:fx/src/journeys/use_cases/delete_journey_use_case.dart';
import 'package:fx/src/journeys/use_cases/get_my_journeys_use_case.dart';
import 'package:fx/src/journeys/use_cases/update_journey_use_case.dart';
import 'package:fx/src/network_manager/network_manager.dart';


export 'business_objects/journey.dart';
export 'business_objects/journeys_balloon_action.dart';

export 'package:fx/src/network_manager/network_manager.dart';
export 'package:fx/src/network_manager/network_manager_ui.dart';
export 'package:dart/dart.dart';
export 'package:ffred/dart.dart';

export 'repositories/journeys_repository.dart';
export 'use_cases/create_journey_use_case.dart';
export 'use_cases/get_my_journeys_use_case.dart';
export 'use_cases/delete_journey_use_case.dart';
export 'use_cases/create_going_home_journey_use_case.dart';
export 'ui/journeys_page_builder.dart';
export 'exceptions/journey_overlapped_exception.dart';

class JourneysTegModule extends TegModule {
  const JourneysTegModule();

  @override
  TegException? exceptionSerializer(String type, Map<String, Object?> json) {
    switch (type) {
      case JourneyOverlappedException.key:
        return JourneyOverlappedException.fromJson(json);
      default:
        return null;
    }
  }

  @override
  TegException? dioErrorMapper(DioException error) {
    final errorResponse = error.response;

    if (errorResponse != null) {
      final hasOverlapsJourneys = errorResponse.data
          .toString()
          .contains(JourneyOverlappedException.overlappedJourneyIdsKey);

      if (errorResponse.statusCode == HttpStatus.conflict &&
          hasOverlapsJourneys) {
        return JourneyOverlappedException.fromResponse(errorResponse);
      }
    }
    return null;
  }

  @override
  Future<void> initializeDependencyGraph(GetIt di) async {
    di
      ..registerSingletonWithDependencies<JourneyApi>(
        () {
          return JourneyApi(di.get<TegNetworkManager>().client);
        },
        dependsOn: <Type>[TegNetworkManager],
      )
      ..registerSingletonWithDependencies<JourneysRemoteDataSource>(
        () {
          return TegJourneysRemoteDataSource(di.get<JourneyApi>());
        },
        dependsOn: <Type>[JourneyApi],
      )
      ..registerSingletonWithDependencies<JourneysRepository>(
        () {
          return JourneysRepository(
            di.get<JourneysRemoteDataSource>(),
          );
        },
        dependsOn: <Type>[JourneysRemoteDataSource],
      )
      ..registerFactory<GetMyJourneysUseCase>(() {
        return GetMyJourneysUseCase(di.get());
      })
      ..registerFactory<CreateJourneyUseCase>(() {
        return CreateJourneyUseCase(di.get());
      })
      ..registerFactory<UpdateJourneyUseCase>(() {
        return UpdateJourneyUseCase(di.get());
      })
      ..registerFactory<DeleteJourneyUseCase>(() {
        return DeleteJourneyUseCase(di.get());
      })
      ..registerFactory(() {
        return CreateGoingHomeJourneyUseCase(
          di.get(),
          di.get(),
          di.get(),
          di.get(),
        );
      });

    await di.allReady();
  }
}


''',
  result: r'''
library journey;

import 'dart:io';

import 'package:fx/src/common/common.dart';
import 'package:fx/src/journeys/data_sources/journeys_remote_data_source.dart';
import 'package:fx/src/journeys/data_sources/teg/journey_api.dart';
import 'package:fx/src/journeys/data_sources/teg/teg_journeys_remote_data_source.dart';
import 'package:fx/src/journeys/exceptions/journey_overlapped_exception.dart';
import 'package:fx/src/journeys/repositories/journeys_repository.dart';
import 'package:fx/src/journeys/use_cases/create_going_home_journey_use_case.dart';
import 'package:fx/src/journeys/use_cases/create_journey_use_case.dart';
import 'package:fx/src/journeys/use_cases/delete_journey_use_case.dart';
import 'package:fx/src/journeys/use_cases/get_my_journeys_use_case.dart';
import 'package:fx/src/journeys/use_cases/update_journey_use_case.dart';
import 'package:fx/src/network_manager/network_manager.dart';

export 'business_objects/journey.dart';
export 'business_objects/journeys_balloon_action.dart';

export 'repositories/journeys_repository.dart';
export 'use_cases/create_journey_use_case.dart';
export 'use_cases/get_my_journeys_use_case.dart';
export 'use_cases/delete_journey_use_case.dart';
export 'use_cases/create_going_home_journey_use_case.dart';
export 'ui/journeys_page_builder.dart';
export 'exceptions/journey_overlapped_exception.dart';

class JourneysTegModule extends TegModule {
  const JourneysTegModule();

  @override
  TegException? exceptionSerializer(String type, Map<String, Object?> json) {
    switch (type) {
      case JourneyOverlappedException.key:
        return JourneyOverlappedException.fromJson(json);
      default:
        return null;
    }
  }

  @override
  TegException? dioErrorMapper(DioException error) {
    final errorResponse = error.response;

    if (errorResponse != null) {
      final hasOverlapsJourneys = errorResponse.data
          .toString()
          .contains(JourneyOverlappedException.overlappedJourneyIdsKey);

      if (errorResponse.statusCode == HttpStatus.conflict &&
          hasOverlapsJourneys) {
        return JourneyOverlappedException.fromResponse(errorResponse);
      }
    }
    return null;
  }

  @override
  Future<void> initializeDependencyGraph(GetIt di) async {
    di
      ..registerSingletonWithDependencies<JourneyApi>(
        () {
          return JourneyApi(di.get<TegNetworkManager>().client);
        },
        dependsOn: <Type>[TegNetworkManager],
      )
      ..registerSingletonWithDependencies<JourneysRemoteDataSource>(
        () {
          return TegJourneysRemoteDataSource(di.get<JourneyApi>());
        },
        dependsOn: <Type>[JourneyApi],
      )
      ..registerSingletonWithDependencies<JourneysRepository>(
        () {
          return JourneysRepository(
            di.get<JourneysRemoteDataSource>(),
          );
        },
        dependsOn: <Type>[JourneysRemoteDataSource],
      )
      ..registerFactory<GetMyJourneysUseCase>(() {
        return GetMyJourneysUseCase(di.get());
      })
      ..registerFactory<CreateJourneyUseCase>(() {
        return CreateJourneyUseCase(di.get());
      })
      ..registerFactory<UpdateJourneyUseCase>(() {
        return UpdateJourneyUseCase(di.get());
      })
      ..registerFactory<DeleteJourneyUseCase>(() {
        return DeleteJourneyUseCase(di.get());
      })
      ..registerFactory(() {
        return CreateGoingHomeJourneyUseCase(
          di.get(),
          di.get(),
          di.get(),
          di.get(),
        );
      });

    await di.allReady();
  }
}

''',
);
