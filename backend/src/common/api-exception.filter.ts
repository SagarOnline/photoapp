import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Request, Response } from 'express';

@Catch()
export class ApiExceptionFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost): void {
    const context = host.switchToHttp();
    const response = context.getResponse<Response>();
    const request = context.getRequest<Request>();
    const status = exception instanceof HttpException
      ? exception.getStatus()
      : HttpStatus.INTERNAL_SERVER_ERROR;
    const payload = exception instanceof HttpException ? exception.getResponse() : null;
    const details = typeof payload === 'object' && payload !== null ? payload : {};
    const body = details as Record<string, unknown>;
    const message = typeof body.message === 'string'
      ? body.message
      : status >= 500
        ? 'An unexpected server error occurred.'
        : Array.isArray(body.message)
          ? 'Request validation failed.'
          : 'Request failed.';
    response.status(status).json({
      statusCode: status,
      code: typeof body.code === 'string' ? body.code : this.defaultCode(status),
      message,
      ...(Array.isArray(body.message) ? { details: body.message } : {}),
      path: request.url,
    });
  }

  private defaultCode(status: number): string {
    switch (status) {
      case 400: return 'VALIDATION_ERROR';
      case 401: return 'UNAUTHENTICATED';
      case 403: return 'FORBIDDEN';
      case 404: return 'NOT_FOUND';
      case 409: return 'CONFLICT';
      default: return status >= 500 ? 'INTERNAL_ERROR' : 'REQUEST_FAILED';
    }
  }
}