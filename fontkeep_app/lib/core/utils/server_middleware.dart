import 'dart:convert';

import 'package:fontkeep_app/core/services/logger_service.dart';
import 'package:shelf/shelf.dart';

Middleware errorHandlingMiddleware(LoggerService logger) {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (error, stackTrace) {
        logger.error(error, stack: stackTrace);
        return Response.internalServerError(
          body: jsonEncode({'error': true, 'message': error.toString()}),
          headers: {'Content-Type': 'application/json'},
        );
      }
    };
  };
}

Middleware loggingMiddleware(LoggerService logger) {
  return (Handler innerHandler) {
    return (Request request) async {
      final method = request.method;
      final url = request.requestedUri.path;
      logger.info('[$method] $url');
      return await innerHandler(request);
    };
  };
}
