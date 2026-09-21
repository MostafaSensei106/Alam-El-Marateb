import 'package:core_network/core_network.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../api_routes.dart';
import 'models/crm_dto.dart';
import 'models/product_dto.dart';

part 'crm_api.g.dart';

/// CRM backoffice (warranties/claims/reviews) + customer portal
/// (profile/addresses/favorites/warranties/loyalty).
@RestApi()
abstract class CrmApi {
  factory CrmApi(Dio dio) = _CrmApi;

  // ── backoffice warranties ──────────────────────────────────────

  @GET(CrmAdminRoutes.warrantyBySerial)
  Future<ApiResponse<WarrantyDto>> warrantyBySerial(
    @Path('serialNumber') String serial,
  );

  @POST(CrmAdminRoutes.scheduleInspection)
  Future<ApiResponse<ClaimDto>> scheduleInspection(
    @Path('claimId') String claimId,
    @Body() Map<String, dynamic> inspection,
  );

  @POST(CrmAdminRoutes.resolveReplace)
  Future<ApiResponse<ClaimDto>> resolveReplace(
    @Path('claimId') String claimId,
  );

  @POST(CrmAdminRoutes.resolveRepair)
  Future<ApiResponse<ClaimDto>> resolveRepair(
    @Path('claimId') String claimId,
  );

  @POST(CrmAdminRoutes.reviewModerate)
  Future<ApiResponse<EmptyDto>> moderateReview(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  // ── customer portal ────────────────────────────────────────────

  @GET(PortalRoutes.profile)
  Future<ApiResponse<ProfileDto>> myProfile();

  @GET(PortalRoutes.addresses)
  Future<ApiResponse<List<AddressDto>>> myAddresses();

  @POST(PortalRoutes.addresses)
  Future<ApiResponse<AddressDto>> saveAddress(
    @Body() Map<String, dynamic> address,
  );

  @DELETE(PortalRoutes.addressById)
  Future<ApiResponse<EmptyDto>> deleteAddress(
    @Path('addressId') String addressId,
  );

  @GET(PortalRoutes.favorites)
  Future<ApiResponse<List<String>>> favorites();

  @POST(PortalRoutes.favorites)
  Future<ApiResponse<EmptyDto>> addFavorite(
    @Body() Map<String, dynamic> body,
  );

  @DELETE(PortalRoutes.favoriteByProduct)
  Future<ApiResponse<EmptyDto>> removeFavorite(
    @Path('productId') String productId,
  );

  @POST(PortalRoutes.warrantyRegister)
  Future<ApiResponse<WarrantyDto>> registerWarranty(
    @Body() Map<String, dynamic> body,
  );

  @GET(PortalRoutes.warrantyVerify)
  @Extra({requireTokenKey: false})
  Future<ApiResponse<WarrantyDto>> verifyWarranty(
    @Path('serialNumber') String serial,
  );

  @GET(PortalRoutes.myWarranties)
  Future<ApiResponse<List<WarrantyDto>>> myWarranties();

  @GET(PortalRoutes.warrantyClaims)
  Future<ApiResponse<List<ClaimDto>>> myClaims();

  @POST(PortalRoutes.warrantyClaims)
  Future<ApiResponse<ClaimDto>> submitClaim(
    @Body() Map<String, dynamic> claim,
  );

  @POST(PortalRoutes.reviews)
  Future<ApiResponse<EmptyDto>> submitReview(
    @Body() Map<String, dynamic> review,
  );

  @GET(PortalRoutes.myReviews)
  Future<ApiResponse<List<ReviewDto>>> myReviews();

  @GET(PortalRoutes.loyalty)
  Future<ApiResponse<LoyaltyBalanceDto>> loyalty();

  @GET(PortalRoutes.loyaltyLedger)
  Future<ApiResponse<List<LoyaltyEntryDto>>> loyaltyLedger();

  @POST(PortalRoutes.loyaltyQuote)
  Future<ApiResponse<LoyaltyQuoteDto>> loyaltyQuote(
    @Body() Map<String, dynamic> body,
  );
}
