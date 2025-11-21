import 'package:demalu/ui/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProposalsCardWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final int? likes;
  final int? dislikes;
  final String date;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback? onTap;

  const ProposalsCardWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.likes = 0,
    this.dislikes = 0,
    required this.date,
    required this.onLike,
    required this.onDislike,
    this.onTap, 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, 
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/compass.svg',
                      width: 44,
                      height: 44,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.heading4.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '$likes',
                        style: AppTextStyles.paragraph4.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                      IconButton(
                        onPressed: onLike, 
                        icon: const Icon(Icons.thumb_up, size: 16),
                      ),
                      Text(
                        '$dislikes',
                        style: AppTextStyles.paragraph4.copyWith(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                        ),
                      ),
                      IconButton(
                        onPressed: onDislike, 
                        icon: const Icon(Icons.thumb_down, size: 16),
                      ),
                    ],
                  ),
                  Text(
                    date,
                    style: AppTextStyles.paragraph4.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}