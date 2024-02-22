import 'dart:convert';

CloudinaryUploadResponse cloudinaryUploadResponseFromJson(String str) =>
    CloudinaryUploadResponse.fromJson(json.decode(str));

String cloudinaryUploadResponseToJson(CloudinaryUploadResponse data) =>
    json.encode(data.toJson());

class CloudinaryUploadResponse {
  final String? assetId;
  final String? publicId;
  final int? version;
  final String? versionId;
  final String? signature;
  final int? width;
  final int? height;
  final String? format;
  final String? resourceType;
  final DateTime? createdAt;
  final List<dynamic>? tags;
  final int? bytes;
  final String? type;
  final String? etag;
  final bool? placeholder;
  final String? url;
  final String? secureUrl;
  final String? folder;
  final String? accessMode;
  final String? originalFilename;

  CloudinaryUploadResponse({
    this.assetId,
    this.publicId,
    this.version,
    this.versionId,
    this.signature,
    this.width,
    this.height,
    this.format,
    this.resourceType,
    this.createdAt,
    this.tags,
    this.bytes,
    this.type,
    this.etag,
    this.placeholder,
    this.url,
    this.secureUrl,
    this.folder,
    this.accessMode,
    this.originalFilename,
  });

  factory CloudinaryUploadResponse.fromJson(Map<String, dynamic> json) =>
      CloudinaryUploadResponse(
        assetId: json["asset_id"],
        publicId: json["public_id"],
        version: json["version"],
        versionId: json["version_id"],
        signature: json["signature"],
        width: json["width"],
        height: json["height"],
        format: json["format"],
        resourceType: json["resource_type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        tags: json["tags"] == null
            ? []
            : List<dynamic>.from(json["tags"]!.map((x) => x)),
        bytes: json["bytes"],
        type: json["type"],
        etag: json["etag"],
        placeholder: json["placeholder"],
        url: json["url"],
        secureUrl: json["secure_url"],
        folder: json["folder"],
        accessMode: json["access_mode"],
        originalFilename: json["original_filename"],
      );

  Map<String, dynamic> toJson() => {
        "asset_id": assetId,
        "public_id": publicId,
        "version": version,
        "version_id": versionId,
        "signature": signature,
        "width": width,
        "height": height,
        "format": format,
        "resource_type": resourceType,
        "created_at": createdAt?.toIso8601String(),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x)),
        "bytes": bytes,
        "type": type,
        "etag": etag,
        "placeholder": placeholder,
        "url": url,
        "secure_url": secureUrl,
        "folder": folder,
        "access_mode": accessMode,
        "original_filename": originalFilename,
      };
}
