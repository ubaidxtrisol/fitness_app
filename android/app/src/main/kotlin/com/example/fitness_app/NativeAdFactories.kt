package com.example.fitness_app

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.NativeAdFactory
import com.example.fitness_app.databinding.AdNativeLargeBinding
import com.example.fitness_app.databinding.AdNativeMediumBinding
import com.example.fitness_app.databinding.AdNativeSmallBinding

class SmallNativeAdFactory(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(nativeAd: NativeAd, customOptions: MutableMap<String, Any>?): NativeAdView {
        val binding = AdNativeSmallBinding.inflate(LayoutInflater.from(context), null, false)
        populateNativeAdView(
            nativeAd = nativeAd,
            adView = binding.root,
            mediaView = null,
            headlineView = binding.adHeadline,
            bodyView = binding.adBody,
            callToActionView = binding.adCallToAction,
            iconView = binding.adAppIcon
        )
        return binding.root
    }
}

class MediumNativeAdFactory(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(nativeAd: NativeAd, customOptions: MutableMap<String, Any>?): NativeAdView {
        val binding = AdNativeMediumBinding.inflate(LayoutInflater.from(context), null, false)
        populateNativeAdView(
            nativeAd = nativeAd,
            adView = binding.root,
            mediaView = binding.adMedia,
            headlineView = binding.adHeadline,
            bodyView = binding.adBody,
            callToActionView = binding.adCallToAction,
            iconView = binding.adAppIcon
        )
        return binding.root
    }
}

class LargeNativeAdFactory(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(nativeAd: NativeAd, customOptions: MutableMap<String, Any>?): NativeAdView {
        val binding = AdNativeLargeBinding.inflate(LayoutInflater.from(context), null, false)
        populateNativeAdView(
            nativeAd = nativeAd,
            adView = binding.root,
            mediaView = binding.adMedia,
            headlineView = binding.adHeadline,
            bodyView = binding.adBody,
            callToActionView = binding.adCallToAction,
            iconView = binding.adAppIcon
        )
        return binding.root
    }
}

fun populateNativeAdView(
    nativeAd: NativeAd,
    adView: NativeAdView,
    mediaView: MediaView?,
    headlineView: TextView?,
    bodyView: TextView?,
    callToActionView: Button?,
    iconView: ImageView?
) {
    // Set the views.
    adView.mediaView = mediaView
    adView.headlineView = headlineView
    adView.bodyView = bodyView
    adView.callToActionView = callToActionView
    adView.iconView = iconView

    // The headline and media content are guaranteed to be in every UnifiedNativeAd.
    headlineView?.text = nativeAd.headline

    if (mediaView != null) {
        if (nativeAd.mediaContent != null) {
            mediaView.mediaContent = nativeAd.mediaContent
            mediaView.visibility = View.VISIBLE
        } else {
            mediaView.visibility = View.GONE
        }
    }

    // These assets aren't guaranteed to be in every UnifiedNativeAd, so it's important to
    // check before trying to display them.
    if (nativeAd.body == null) {
        bodyView?.visibility = View.INVISIBLE
    } else {
        bodyView?.visibility = View.VISIBLE
        bodyView?.text = nativeAd.body
    }

    if (nativeAd.callToAction == null) {
        callToActionView?.visibility = View.INVISIBLE
    } else {
        callToActionView?.visibility = View.VISIBLE
        callToActionView?.text = nativeAd.callToAction
    }

    if (nativeAd.icon == null) {
        iconView?.visibility = View.GONE
    } else {
        iconView?.setImageDrawable(nativeAd.icon?.drawable)
        iconView?.visibility = View.VISIBLE
    }

    // This method tells the Google Mobile Ads SDK that you have finished populating your
    // native ad view with this native ad.
    adView.setNativeAd(nativeAd)
}
