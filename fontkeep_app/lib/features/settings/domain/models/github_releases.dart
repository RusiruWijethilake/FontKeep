import 'dart:convert';

List<GitHubReleases> gitHubReleasesFromJson(String str) =>
    List<GitHubReleases>.from(
      json.decode(str).map((x) => GitHubReleases.fromJson(x)),
    );

String gitHubReleasesToJson(List<GitHubReleases> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GitHubReleases {
  String url;
  String assetsUrl;
  String uploadUrl;
  String htmlUrl;
  int id;
  Author author;
  String nodeId;
  String tagName;
  String targetCommitish;
  String name;
  bool draft;
  bool immutable;
  bool prerelease;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime publishedAt;
  List<Asset> assets;
  String tarballUrl;
  String zipballUrl;
  String body;

  GitHubReleases({
    required this.url,
    required this.assetsUrl,
    required this.uploadUrl,
    required this.htmlUrl,
    required this.id,
    required this.author,
    required this.nodeId,
    required this.tagName,
    required this.targetCommitish,
    required this.name,
    required this.draft,
    required this.immutable,
    required this.prerelease,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.assets,
    required this.tarballUrl,
    required this.zipballUrl,
    required this.body,
  });

  factory GitHubReleases.fromJson(Map<String, dynamic> json) => GitHubReleases(
    url: json["url"],
    assetsUrl: json["assets_url"],
    uploadUrl: json["upload_url"],
    htmlUrl: json["html_url"],
    id: json["id"],
    author: Author.fromJson(json["author"]),
    nodeId: json["node_id"],
    tagName: json["tag_name"],
    targetCommitish: json["target_commitish"],
    name: json["name"],
    draft: json["draft"],
    immutable: json["immutable"],
    prerelease: json["prerelease"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    publishedAt: DateTime.parse(json["published_at"]),
    assets: List<Asset>.from(json["assets"].map((x) => Asset.fromJson(x))),
    tarballUrl: json["tarball_url"],
    zipballUrl: json["zipball_url"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "assets_url": assetsUrl,
    "upload_url": uploadUrl,
    "html_url": htmlUrl,
    "id": id,
    "author": author.toJson(),
    "node_id": nodeId,
    "tag_name": tagName,
    "target_commitish": targetCommitish,
    "name": name,
    "draft": draft,
    "immutable": immutable,
    "prerelease": prerelease,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "published_at": publishedAt.toIso8601String(),
    "assets": List<dynamic>.from(assets.map((x) => x.toJson())),
    "tarball_url": tarballUrl,
    "zipball_url": zipballUrl,
    "body": body,
  };
}

class Asset {
  String url;
  int id;
  String nodeId;
  String name;
  String label;
  Author uploader;
  String contentType;
  String state;
  int size;
  String digest;
  int downloadCount;
  DateTime createdAt;
  DateTime updatedAt;
  String browserDownloadUrl;

  Asset({
    required this.url,
    required this.id,
    required this.nodeId,
    required this.name,
    required this.label,
    required this.uploader,
    required this.contentType,
    required this.state,
    required this.size,
    required this.digest,
    required this.downloadCount,
    required this.createdAt,
    required this.updatedAt,
    required this.browserDownloadUrl,
  });

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
    url: json["url"],
    id: json["id"],
    nodeId: json["node_id"],
    name: json["name"],
    label: json["label"],
    uploader: Author.fromJson(json["uploader"]),
    contentType: json["content_type"],
    state: json["state"],
    size: json["size"],
    digest: json["digest"],
    downloadCount: json["download_count"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    browserDownloadUrl: json["browser_download_url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "id": id,
    "node_id": nodeId,
    "name": name,
    "label": label,
    "uploader": uploader.toJson(),
    "content_type": contentType,
    "state": state,
    "size": size,
    "digest": digest,
    "download_count": downloadCount,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "browser_download_url": browserDownloadUrl,
  };
}

class Author {
  String login;
  int id;
  String nodeId;
  String avatarUrl;
  String gravatarId;
  String url;
  String htmlUrl;
  String followersUrl;
  String followingUrl;
  String gistsUrl;
  String starredUrl;
  String subscriptionsUrl;
  String organizationsUrl;
  String reposUrl;
  String eventsUrl;
  String receivedEventsUrl;
  String type;
  String userViewType;
  bool siteAdmin;

  Author({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.gravatarId,
    required this.url,
    required this.htmlUrl,
    required this.followersUrl,
    required this.followingUrl,
    required this.gistsUrl,
    required this.starredUrl,
    required this.subscriptionsUrl,
    required this.organizationsUrl,
    required this.reposUrl,
    required this.eventsUrl,
    required this.receivedEventsUrl,
    required this.type,
    required this.userViewType,
    required this.siteAdmin,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    login: json["login"],
    id: json["id"],
    nodeId: json["node_id"],
    avatarUrl: json["avatar_url"],
    gravatarId: json["gravatar_id"],
    url: json["url"],
    htmlUrl: json["html_url"],
    followersUrl: json["followers_url"],
    followingUrl: json["following_url"],
    gistsUrl: json["gists_url"],
    starredUrl: json["starred_url"],
    subscriptionsUrl: json["subscriptions_url"],
    organizationsUrl: json["organizations_url"],
    reposUrl: json["repos_url"],
    eventsUrl: json["events_url"],
    receivedEventsUrl: json["received_events_url"],
    type: json["type"],
    userViewType: json["user_view_type"],
    siteAdmin: json["site_admin"],
  );

  Map<String, dynamic> toJson() => {
    "login": login,
    "id": id,
    "node_id": nodeId,
    "avatar_url": avatarUrl,
    "gravatar_id": gravatarId,
    "url": url,
    "html_url": htmlUrl,
    "followers_url": followersUrl,
    "following_url": followingUrl,
    "gists_url": gistsUrl,
    "starred_url": starredUrl,
    "subscriptions_url": subscriptionsUrl,
    "organizations_url": organizationsUrl,
    "repos_url": reposUrl,
    "events_url": eventsUrl,
    "received_events_url": receivedEventsUrl,
    "type": type,
    "user_view_type": userViewType,
    "site_admin": siteAdmin,
  };
}
